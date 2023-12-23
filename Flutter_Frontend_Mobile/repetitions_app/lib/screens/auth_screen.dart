import 'dart:io';
import 'dart:math';

import '../variables/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  myColors.tertiary.withOpacity(1),
                  myColors.primary.withOpacity(0.6),
                  //const Color.fromRGBO(246, 255, 208, 1.0).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      width: deviceSize.width * 0.70,
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0, /*horizontal: 94.0*/),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: myColors.primary,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: myColors.tertiary,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Flex(
                        direction: Axis.horizontal,
                        children:[ Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school, color: myColors.lightSecondary,
                                  size:deviceSize.width * 0.08),
                              SizedBox(width: deviceSize.width * 0.015,),
                              Text(
                                'Tutoring Service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceSize.width * 0.06,
                                  //fontFamily: 'Anton',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.03,
                  ),
                  GuestLogin(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('An error occurred'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Ok'))
            ],
          ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        //await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password']);
        await Provider.of<Auth>(context, listen: false).authenticate(
            _authData['email'], _authData['password']);
      } else {
        // Sign user up
        //await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INCORRECT')) {
        errorMessage = 'Incorrect email or password';
      } else if (error.toString().contains('INVALID_USERNAME_PASSWORD')) {
        errorMessage = 'Invalid email or password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: myColors.tertiary,
              offset: Offset(0, 10),
            )
          ],
        ),
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
        BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person_outlined,
                          color: Theme
                              .of(context)
                              .primaryColor),
                      labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock_outline,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),
                      labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock,
                            color: Theme
                                .of(context)
                                .primaryColor),
                        labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                    }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                // ignore: sdk_version_ui_as_code
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme
                              .of(context)
                              .primaryColor),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme
                              .of(context)
                              .primaryTextTheme
                              .labelLarge
                              .color),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP')),
                  ),
                MaterialButton(
                  onPressed: _switchAuthMode,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(
                      '${_authMode == AuthMode.Login
                          ? 'SIGNUP'
                          : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class GuestLogin extends StatefulWidget {
  @override
  State<GuestLogin> createState() => _GuestLoginState();
}

class _GuestLoginState extends State<GuestLogin> {
  @override
  bool _onHover = false;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t want to register? ',
          style: TextStyle(color: Colors.white,),
        ),
        InkWell(
          onTap: () {
            Provider.of<Auth>(context, listen: false).guestLogin();
          },
          onHover: (isHovering) {
            if (isHovering) {
              setState(() {
                _onHover = true;
              });
            }
            else {
              setState(() {
                _onHover = false;
              });
            }
          },

          splashColor: myColors.secondary,
          child: Text(
            'Enter as a guest!',
            style: TextStyle(
              color: _onHover ? myColors.lightSecondary : Colors.white,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.clip,
              decoration: _onHover ? TextDecoration.underline : TextDecoration
                  .none,
            ),
          ),
        )
      ],
    );
  }
}
