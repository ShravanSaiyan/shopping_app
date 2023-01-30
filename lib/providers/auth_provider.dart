import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;
  String? _userId;

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> signUp(String email, String password) async {
    String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyArQbgqCNqw8udegj7i05wm-JlLa-uDI04";
    var uri = Uri.parse(url);

    try {
      final response = await http.post(uri,
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      final responseData = jsonDecode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _userId = responseData["localId"];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyArQbgqCNqw8udegj7i05wm-JlLa-uDI04";
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = jsonDecode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _userId = responseData["localId"];
      _autoLogOut();
      notifyListeners();
      final sharedPreferences = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toString(),
      });
      sharedPreferences.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> isAutoLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey("userData")) {
      return false;
    }

    final userData = jsonDecode(sharedPreferences.getString("userData")!);

    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData["token"];
    _userId = userData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("userData");
    notifyListeners();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    var timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}
