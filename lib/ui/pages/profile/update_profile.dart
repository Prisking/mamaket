import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/home/controller/home_controller.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:mamaket/ui/pages/profile/widgets/account_type.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final User user = Hive.box("userData").get("user");

  @override
  void initState() {
    super.initState();
    firstname.text = user.name.split(" ")[0];
    lastname.text = user.name.split(" ")[1];
    phoneNumber.text = user.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeController>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileController>(context, listen: false);
    profileProvider.setCurrentGroupValue(user.role);
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
        title: Text("Update Details"),
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
                controller: firstname,
                decoration: InputDecoration(labelText: 'First Name'),
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
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your phone number';
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
                              profileProvider.updateProfile(firstname.text,
                                  lastname.text, phoneNumber.text);
                              home.setCurrentIndex(0);
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
