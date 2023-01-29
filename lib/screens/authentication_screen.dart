import 'dart:math';

import 'package:flutter/material.dart';

enum AuthenticationMode { signUp, login }

class AuthenticationScreen extends StatelessWidget {
  static const routeName = "/authentication";

  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ]),
                    child: Text(
                      "Shopping!!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: const AuthCard())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthenticationMode _authenticationMode = AuthenticationMode.login;
  Map<String, String> _authData = {"email": "", "password": ""};
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authenticationMode == AuthenticationMode.login) {
      // log user
    } else {
      // sign up
    }
  }

  void _switchAuthMode() {
    if (_authenticationMode == AuthenticationMode.login) {
      setState(() {
        _authenticationMode = AuthenticationMode.signUp;
      });
    } else {
      setState(() {
        _authenticationMode = AuthenticationMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: _authenticationMode == AuthenticationMode.signUp ? 320 : 260,
        constraints: BoxConstraints(
            minHeight:
                _authenticationMode == AuthenticationMode.signUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "E-Mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter the email";
                    } else if (!value.contains("@")) {
                      return "Invalid Email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData["email"] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter the password";
                    } else if (value.length < 5) {
                      return "The password size must be greater than 5 characters";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData["password"] = value!;
                  },
                ),
                if (_authenticationMode == AuthenticationMode.signUp)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter the password";
                      } else if (value.length < 5) {
                        return "The password size must be greater than 5 characters";
                      } else if (_passwordController.text != value) {
                        return "Passwords does not match";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData["password"] = value!;
                    },
                  ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .button
                                ?.color))),
                    child: Text(_authenticationMode == AuthenticationMode.login
                        ? "LOGIN"
                        : "SIGNUP"),
                  ),
                TextButton(
                    onPressed: _switchAuthMode,
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 4)),
                        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: MaterialStatePropertyAll(
                            TextStyle(color: Theme.of(context).primaryColor))),
                    child: Text(_authenticationMode == AuthenticationMode.login
                        ? "SIGNUP"
                        : "LOGIN"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
