import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/ui/pages/messaging/models/notification.dart';

class HomeController extends ChangeNotifier {
  int _currentIndex = 0;

  final Box userData = Hive.box('userData');

  int get currentIndex {
    return _currentIndex;
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () {
              Get.back();
            },
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  void logoutRequest() {
    showLogoutDialog();
  }

  void logout() {
    setCurrentIndex(0);
    Get.toNamed("/sign-in");
    userData.delete("user");
    userData.delete("accessToken");
  }

  void showSnackbar(message) {
    final notificationTitle = message['notification']['title'];
    final notificationBody = message['notification']['body'];

    Get.snackbar(
      notificationTitle,
      notificationBody,
      barBlur: 20,
      borderRadius: 25.0,
      animationDuration: Duration(milliseconds: 500),
      backgroundColor: Colors.white.withOpacity(0.8),
      isDismissible: true,
      duration: Duration(seconds: 3),
      onTap: (snack) {
        navigate(message);
      },
    );
  }

  navigate(message) {
    final conversationId = message['data']['id'];
    final refProduct = message['data']['refProduct'];
    final participants = json.decode(message['data']['participants']) as List;

    final partMap = participants
        .map((e) => ParticipantMod(e['_id'], e['name'], e['image']))
        .toList();

    final data = NotificationMod(conversationId, refProduct, partMap);

    Get.toNamed("/notification-chat", arguments: data);
  }
}
