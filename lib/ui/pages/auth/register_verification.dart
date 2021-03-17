import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

import 'controller/auth_controller.dart';

class RegisterVerification extends StatefulWidget {
  @override
  _RegisterVerificationState createState() => _RegisterVerificationState();
}

class _RegisterVerificationState extends State<RegisterVerification> {
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String errorMessage;
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
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Registration Verification",
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
                        SizedBox(height: 50.0),
                        PinCodeTextField(
                          autofocus: true,
                          controller: controller,
                          hideCharacter: true,
                          highlight: true,
                          highlightColor: kPrimaryColor,
                          defaultBorderColor: kPrimaryColor,
                          hasTextBorderColor: Colors.green,
                          maxLength: pinLength,
                          hasError: hasError,
                          maskCharacter: "*",
                          onTextChanged: (text) {
                            setState(() {
                              hasError = false;
                            });
                          },
                          onDone: (text) {
                            authProvider.confirmEmail(text);
                          },
                          wrapAlignment: WrapAlignment.spaceBetween,
                          pinBoxDecoration:
                              ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                          pinTextStyle: TextStyle(fontSize: 30.0),
                          pinTextAnimatedSwitcherTransition:
                              ProvidedPinBoxTextAnimation.scalingTransition,
                          pinTextAnimatedSwitcherDuration:
                              Duration(milliseconds: 300),
                          pinBoxWidth: 30,
                          pinBoxHeight: 30,
                          pinBoxRadius: 4.0,
                          pinBoxBorderWidth: 1,
                          highlightAnimationBeginColor: Colors.black,
                          highlightAnimationEndColor: Colors.white12,
                          keyboardType: TextInputType.number,
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
                                      if (controller.text.length < 6) {
                                        return null;
                                      }
                                      authProvider
                                          .confirmEmail(controller.text);
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
                                            "Verify",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              InkWell(
                                child: Text(
                                  "Resend Verification",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () {},
                              )
                            ],
                          ),
                        ),
                      ],
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
                      onPressed: () {},
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
