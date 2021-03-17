import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/home/controller/home_controller.dart';
import 'package:provider/provider.dart';

class AccountSetings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              title: Text("Contact Details"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed("/update-profile");
              },
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed("/change-password");
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              title: Text("Change Password"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/about-page");
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              title: Text("About Us"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                home.logoutRequest();
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              title: Text("Log Out"),
              trailing: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}
