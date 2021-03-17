import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class UpdateRegion extends StatefulWidget {
  @override
  _UpdateRegionState createState() => _UpdateRegionState();
}

class _UpdateRegionState extends State<UpdateRegion> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        final profileController =
            Provider.of<ProfileController>(context, listen: false);
        profileController.getCities();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Store Region")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: profileController.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a city';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        profileController.setCity(value);
                      },
                      items: profileController.cities.map(
                        (city) {
                          return DropdownMenuItem(
                            value: city.name,
                            child: Text(city.name),
                          );
                        },
                      ).toList(),
                      decoration: InputDecoration(labelText: 'Cities'),
                    ),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an area';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        profileController.setAreaAndLatLng(value);
                      },
                      items: profileController.areas.map(
                        (area) {
                          return DropdownMenuItem(
                            value: area.name,
                            child: Text(area.name),
                          );
                        },
                      ).toList(),
                      decoration: InputDecoration(labelText: 'Areas'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 250,
                        height: 45,
                        child: RaisedButton(
                          disabledColor: Colors.grey,
                          color: kPrimaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              profileController.updateUserRegion();
                            }
                          },
                          child: profileController.isDisabled
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
