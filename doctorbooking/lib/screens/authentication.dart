import 'package:doctorbooking/providers/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'role': ''
  };
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;

  Future<void> _submit() async {
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
        await Provider.of<AuthProvider>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        //Sign Up
        await Provider.of<AuthProvider>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
          _authData['name'],
          _authData['role'],
        );
      }
    } catch (error) {
      _showErrorDialog(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: deviceSize.height,
        alignment: Alignment.center,
        child: _isLoading
            ? CircularProgressIndicator()
            : ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: deviceSize.height * 0.2),
                  Text(
                    'Doctor Booking App',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.all(20),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          _authMode == AuthMode.Login
                              ? SizedBox()
                              : TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Invalid name!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _authData['name'] = value;
                                  },
                                ),
                          _authMode == AuthMode.Login
                              ? SizedBox()
                              : SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'E-Mail',
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Password length less than 6';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          _authMode == AuthMode.Login
                              ? SizedBox()
                              : SizedBox(height: 20),
                          _authMode == AuthMode.Login
                              ? SizedBox()
                              : TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.lock),
                                  ),
                                  enabled: _authMode == AuthMode.Signup,
                                  obscureText: true,
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                          _authMode == AuthMode.Login
                              ? SizedBox()
                              : SizedBox(height: 20),
                          _authMode == AuthMode.Login
                              ? SizedBox()
                              : DropdownButtonFormField(
                                  items: [
                                    DropdownMenuItem(
                                        value: 'Doctor', child: Text('Doctor')),
                                    DropdownMenuItem(
                                        value: 'Patient',
                                        child: Text('Patient'))
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _authData['role'] = value;
                                    });
                                  },
                                  hint: Text('Choose Role'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.grain),
                                  ),
                                ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              child: Text(_authMode == AuthMode.Login
                                  ? 'LOGIN'
                                  : 'SIGN UP'),
                              onPressed: _submit,
                            ),
                          ),
                          Center(
                            child: TextButton(
                              child: Text(
                                  '${_authMode == AuthMode.Login ? 'New Here? Signup' : 'Already Have An Account? Login'}'),
                              onPressed: _switchAuthMode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

// class AuthCard extends StatefulWidget {
//   @override
//   _AuthCardState createState() => _AuthCardState();
// }

// class _AuthCardState extends State<AuthCard> {
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
