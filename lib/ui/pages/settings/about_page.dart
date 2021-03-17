import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/services/link_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              height: 150,
              width: 150,
              child: Image.asset("assets/logo.png"),
            ),
            Text(
              "What if all you want is within you?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Mamaket is your number one solution for buying and selling within your community. We are bold to ask this question: What if all you want is within you? And with just a click on your mobile device, we provide you the opportunity to explore and access all the products and services within your neighborhood. With Mamaket you are able to browse what people are selling near you, post items people might need, chat instantly and securely with clients, meetup or get your goods delivered at your door step and tell us about your experience through the app.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Feather.instagram),
                  onPressed: () => LinkLauncher.launchInsta(),
                  color: kPrimaryColor,
                ),
                IconButton(
                  icon: Icon(Feather.twitter),
                  onPressed: () => LinkLauncher.launchTwitter(),
                  color: kPrimaryColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
