import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';

import 'widgets/account_type.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
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
                            "Create an account",
                            style: TextStyle(
                                fontSize: kHeadingFontSize, color: kLightGrey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: firstname,
                            decoration:
                                InputDecoration(labelText: 'First Name'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: lastname,
                            decoration: InputDecoration(labelText: 'Last Name'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: phoneNumber,
                            decoration:
                                InputDecoration(labelText: 'Phone Number'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: email,
                            decoration:
                                InputDecoration(labelText: 'Email Address'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: password,
                            obscureText:
                                authProvider.showPassword ? false : true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    authProvider.changeShowPassword(),
                                icon: Icon(
                                  authProvider.showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Account Type",
                                style: TextStyle(color: kLightGrey),
                              ),
                              Row(
                                children: <Widget>[
                                  AccountType(
                                    value: "buyer",
                                    title: "Buyer",
                                  ),
                                  AccountType(
                                    value: "seller",
                                    title: "Seller",
                                  ),
                                ],
                              ),
                            ],
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
                                      onPressed: () {
                                        if (auth.isDisabled) {
                                          return null;
                                        }
                                        if (_formKey.currentState.validate()) {
                                          authProvider.signUp(
                                              firstname.text,
                                              lastname.text,
                                              phoneNumber.text,
                                              email.text,
                                              password.text);
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
                                              "Sign Up",
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
                        Get.toNamed("/sign-in");
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
