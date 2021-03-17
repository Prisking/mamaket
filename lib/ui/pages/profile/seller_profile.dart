import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/services/star_rating.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class SellerProfile extends StatefulWidget {
  static final userData = Hive.box("userData");

  final user = userData.get("user");

  final String sellerId;
  final int numRating;

  SellerProfile(this.sellerId, this.numRating);

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        final profileProvider =
            Provider.of<ProfileController>(context, listen: false);
        profileProvider.getUser(widget.sellerId);
        profileProvider.getIsRated(widget.sellerId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seller Profile"),
        centerTitle: true,
      ),
      body: Consumer<ProfileController>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!profileProvider.isLoading && profileProvider.profile == null) {
            return Center(
              child: Text("No Data"),
            );
          }
          final userHasRated = profileProvider.isRated != null;
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: _buildAvatar(profileProvider),
                ),
              ),
              Container(
                child: Text(
                  profileProvider.profile.name,
                  style: TextStyle(color: kPrimaryColor, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("Your Rating"),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SmoothStarRating(
                    key: UniqueKey(),
                    allowHalfRating: false,
                    onRated: (v) {
                      profileProvider.setNewRating(v);
                    },
                    starCount: 5,
                    rating: profileProvider.rating.toDouble(),
                    size: 30.0,
                    isReadOnly: false,
                    halfFilledIconData: Icons.blur_on,
                    color: Colors.orangeAccent,
                    borderColor: Colors.orangeAccent,
                    spacing: 0.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("(${widget.numRating})")
                ],
              ),
              SizedBox(
                height: 20,
              ),
              profileProvider.newRating != null
                  ? Container(
                      width: 100,
                      height: 45,
                      color: kLightBlue,
                      padding: EdgeInsets.all(8),
                      child: FlatButton(
                        onPressed: () {
                          if (userHasRated) {
                            profileProvider.editRating();
                          } else {
                            profileProvider.rateSeller(widget.sellerId);
                          }
                        },
                        child: profileProvider.rateLoading
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 30.0,
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
                    // ListTile(
                    //   contentPadding: const EdgeInsets.symmetric(
                    //     horizontal: 12.0,
                    //   ),
                    //   leading: Icon(
                    //     Icons.phone,
                    //     color: kPrimaryColor,
                    //   ),
                    //   title: Text(
                    //     profileProvider.profile.phoneNumber,
                    //   ),
                    // ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      leading: Icon(
                        Icons.pin_drop,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        profileProvider.profile.region,
                      ),
                    ),
                    Container(
                      color: kLightBlue,
                      height: 2,
                    ),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              "/seller-products",
                              arguments: widget.sellerId,
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
                                    "View All Products",
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
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  CircleAvatar _buildAvatar(
    ProfileController profileController,
  ) {
    if (profileController.profile.image == null) {
      return CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 50.0,
        child: Text(
          initials(
            profileController.profile.name,
          ),
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(
        profileController.profile.image,
      ),
      backgroundColor: kPrimaryColor,
      radius: 50.0,
    );
  }

  String initials(String name) {
    String firstname = name.split(" ")[0];
    String lastname = name.split(" ")[1];

    String initials =
        "${firstname[0].toUpperCase()}${lastname[0].toUpperCase()}";
    return initials;
  }

  String capitalize(User box) {
    String role = box.role;
    return "${role[0].toUpperCase()}${role.substring(1)}";
  }
}
