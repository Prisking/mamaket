import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          color: kPrimaryColor,
          width: double.infinity,
          height: 300,
        ),
        SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 70.0, horizontal: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: kLightGrey,
                        width: 0.5,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Create New Password",
                            style: TextStyle(
                                fontSize: kHeadingFontSize, color: kLightGrey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: password,
                            obscureText:
                                authProvider.showPassword ? false : true,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              suffixIcon: _suffixIcon(authProvider),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: password2,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              suffixIcon: _suffixIcon(authProvider),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != password.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 50.0),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 250.0,
                                  height: 45.0,
                                  child: Consumer<AuthController>(
                                    builder: (context, auth, child) =>
                                        RaisedButton(
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        side: BorderSide(color: kPrimaryColor),
                                      ),
                                      onPressed: () {
                                        if (auth.isDisabled) {
                                          return null;
                                        }
                                        if (_formKey.currentState.validate()) {
                                          authProvider.resetPassword(
                                              password.text, password2.text);
                                        }
                                      },
                                      child: auth.isDisabled
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                backgroundColor: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              "Reset Password",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  IconButton _suffixIcon(AuthController authProvider) {
    return IconButton(
      onPressed: () => authProvider.changeShowPassword(),
      icon: Icon(
        authProvider.showPassword ? Icons.visibility : Icons.visibility_off,
      ),
    );
  }
}
