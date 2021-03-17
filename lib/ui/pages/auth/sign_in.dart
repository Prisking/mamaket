import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Mamaket",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
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
                            "Sign In",
                            style: TextStyle(
                                fontSize: kHeadingFontSize, color: kLightGrey),
                            textAlign: TextAlign.center,
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
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: passwordController,
                            obscureText:
                                authProvider.showPassword ? false : true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authProvider.showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  authProvider.changeShowPassword();
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
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
                                          authProvider.signIn(
                                              emailController.text,
                                              passwordController.text);
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
                                              "Sign In",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                InkWell(
                                  child: Text(
                                    "Can't remember your password?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    authProvider.setPasswordVisibilityOff();
                                    Get.toNamed("/forgot-password");
                                  },
                                )
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
                    child: RaisedButton(
                      color: kPrimaryColor,
                      onPressed: () {
                        authProvider.setPasswordVisibilityOff();
                        Get.toNamed("/sign-up");
                      },
                      child: Text(
                        "Create An Account",
                        style: TextStyle(color: Colors.white),
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
