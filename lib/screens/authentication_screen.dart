import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth_provider.dart';

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
            child: SizedBox(
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

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthenticationMode _authenticationMode = AuthenticationMode.login;
  final Map<String, String> _authData = {"email": "", "password": ""};
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation =
        Tween(begin: const Offset(0, -1.5), end: const Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("An error has occurred"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authenticationMode == AuthenticationMode.login) {
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signIn(_authData["email"]!, _authData["password"]!);
      } else {
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signUp(_authData["email"]!, _authData["password"]!);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication Failed";

      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email address is already in use";
      } else if (error.toString().contains("OPERATION_NOT_ALLOWED")) {
        errorMessage = " Password Sign-In has been disabled for this account";
      } else if (error.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        errorMessage = "Too many attempts";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Email Not Found";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid Password";
      } else if (error.toString().contains("USER_DISABLED")) {
        errorMessage = "This user account has been disabled";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = "Authentication failed!";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authenticationMode == AuthenticationMode.login) {
      setState(() {
        _authenticationMode = AuthenticationMode.signUp;
        _animationController.forward();
      });
    } else {
      setState(() {
        _authenticationMode = AuthenticationMode.login;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: AnimatedContainer(
        height: _authenticationMode == AuthenticationMode.signUp ? 320 : 260,
        constraints: BoxConstraints(
            minHeight:
                _authenticationMode == AuthenticationMode.signUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        duration: const Duration(milliseconds: 300),
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
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Confirm Password"),
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
                    ),
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
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
