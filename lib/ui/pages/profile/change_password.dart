import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController password2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: iconSize,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Change Password"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: oldPassword,
                obscureText: profileProvider.showPassword ? false : true,
                decoration: InputDecoration(
                  labelText: 'Enter Current Password',
                  suffixIcon: _suffixIcon(profileProvider),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: newPassword,
                obscureText: profileProvider.showPassword ? false : true,
                decoration: InputDecoration(
                  labelText: 'Enter New Password',
                  suffixIcon: _suffixIcon(profileProvider),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: password2,
                obscureText: profileProvider.showPassword ? false : true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: _suffixIcon(profileProvider),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != newPassword.text) {
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
                        child: Consumer<ProfileController>(
                          builder: (context, profile, child) => RaisedButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: kPrimaryColor),
                            ),
                            onPressed: () {
                              if (profile.isDisabled) {
                                return null;
                              }
                              if (_formKey.currentState.validate()) {
                                profileProvider.changePassword(
                                    oldPassword.text, newPassword.text);
                              }
                            },
                            child: profile.isDisabled
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        )),
                    SizedBox(height: 20.0),
                    InkWell(
                        child: Text(
                          "Can't remember your current password?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("/forgot-password");
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _suffixIcon(ProfileController profileProvider) {
    return IconButton(
      icon: Icon(
        profileProvider.showPassword ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () => profileProvider.changeShowPassword(),
    );
  }
}
