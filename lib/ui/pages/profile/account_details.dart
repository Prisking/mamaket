import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatelessWidget {
  static final userData = Hive.box("userData");
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Account"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.of(context).pushNamed("/account-settings"),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: userData.listenable(),
        builder: (context, box, _) => Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                profileProvider.handlemageSource();
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: _buildAvatar(box, profileProvider),
                ),
              ),
            ),
            Container(
              child: Text(
                box.get("user").name,
                style: TextStyle(color: kPrimaryColor, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    color: kLightBlue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        "Contact Details",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    leading: Icon(
                      Icons.mail,
                      color: kPrimaryColor,
                    ),
                    title: Text(box.get("user").email),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    leading: Icon(
                      Icons.phone,
                      color: kPrimaryColor,
                    ),
                    title: Text(box.get("user").phoneNumber),
                  ),
                  box.get("user").geometry == null
                      ? Container()
                      : ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          leading: Icon(
                            Icons.pin_drop,
                            color: kPrimaryColor,
                          ),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/update-region");
                            },
                            child: Text(
                              "Change",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                          title: Text(box.get("user").region),
                        ),
                  Container(
                    color: kLightBlue,
                    height: 2,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    leading: Icon(
                      Icons.account_circle,
                      color: kPrimaryColor,
                    ),
                    title: Text(
                      "Account Type",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    trailing: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                      child: Text(
                        capitalize(
                          box.get('user'),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  box.get("user").role == "seller"
                      ? Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                final sellerId = box.get("user").id;
                                Get.toNamed(
                                  "/seller-products",
                                  arguments: sellerId,
                                );
                              },
                              child: Container(
                                color: kLightBlue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "My Products",
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: kPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                final sellerId = box.get("user").id;
                                Get.toNamed(
                                  "/sponsored-products",
                                  arguments: sellerId,
                                );
                              },
                              child: Container(
                                color: kLightBlue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "My Promoted Products",
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                      Icon(Icons.chevron_right,
                                          color: kPrimaryColor)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  CircleAvatar _buildAvatar(Box box, ProfileController profileProvider) {
    final user = box.get("user");
    if (user.image == null) {
      return CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 50.0,
        child: profileProvider.isUploading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Text(
                initials(
                  box.get("user"),
                ),
                style: TextStyle(fontSize: 20),
              ),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(box.get("user").image),
      backgroundColor: kPrimaryColor,
      radius: 50.0,
      child: profileProvider.isUploading
          ? CircularProgressIndicator(
              backgroundColor: Colors.white,
            )
          : null,
    );
  }

  String initials(User box) {
    String firstname = box.name.split(" ")[0];
    String lastname = box.name.split(" ")[1];

    String initials =
        "${firstname[0].toUpperCase()}${lastname[0].toUpperCase()}";
    return initials;
  }

  String capitalize(User box) {
    String role = box.role;
    return "${role[0].toUpperCase()}${role.substring(1)}";
  }
}
