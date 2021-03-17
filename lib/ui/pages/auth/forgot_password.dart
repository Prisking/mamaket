import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context, listen: false);
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
                            "Reset Password",
                            style: TextStyle(
                                fontSize: kHeadingFontSize, color: kLightGrey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 300,
                            child: Text(
                              kResetPasswordText,
                              style: TextStyle(fontSize: 14, color: kLightGrey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your email address';
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
                                          authProvider.forgotPassword(
                                              emailController.text);
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
                                              "Continue",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    height: 45,
                    child: OutlineButton(
                      borderSide: BorderSide(color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/sign-in");
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: kPrimaryColor),
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
}
