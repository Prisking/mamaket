import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/services/api_service.dart';

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  bool isDisabled = false;
  bool showPassword = false;
  String resetToken;

  //Radio
  String groupValue = "buyer";
  final Box userData = Hive.box('userData');

  void setDisabled(bool disabled) {
    isDisabled = disabled;
    notifyListeners();
  }

  void changeGroupValue(String value) {
    groupValue = value;
    notifyListeners();
  }

  void changeShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void setPasswordVisibilityOff() {
    showPassword = false;
    notifyListeners();
  }

  void showError(e) {
    final error = e.response.data;
    if (error['message'] is String) {
      showSnackbar("Error", error['message']);
    } else {
      showSnackbar("Error", error['message'][0]);
    }
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      barBlur: 20,
      borderRadius: 25.0,
      animationDuration: Duration(milliseconds: 500),
      backgroundColor: Colors.white.withOpacity(0.8),
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
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

  forgotPassword(String email) async {
    setDisabled(true);
    try {
      final result = await _apiService.forgotPassword(email: email);
      setDisabled(false);
      Get.toNamed("/reset-verification");
      showSnackbar("Success", result);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  requestReset(String token) async {
    resetToken = token;
    setDisabled(true);
    try {
      final _ = await _apiService.requestReset(token: token);
      setDisabled(false);
      Get.toNamed("/reset-password");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  resetPassword(String password, String password2) async {
    setDisabled(true);
    try {
      final _ = await _apiService.resetPassword(
          password: password, password2: password2, token: resetToken);
      setDisabled(false);
      //Save to Hive
      Get.toNamed("/sign-in");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  confirmEmail(String token) async {
    setDisabled(true);
    try {
      final _ = await _apiService.confirmEmail(token: token);
      setDisabled(false);
      Get.toNamed("/sign-in");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  signIn(String email, String password) async {
    setDisabled(true);
    final token = await _fcm.getToken();

    try {
      final result = await _apiService.signIn(
          email: email, password: password, fcmToken: token);
      //Save to Hive
      userData.put("user", result);
      userData.put("accessToken", result.accesstoken);
      // userData.put("geometry", result.geometry);
      setDisabled(false);
      Get.offAllNamed("/home");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  signUp(String firstname, String lastname, String phoneNumber, String email,
      String password) async {
    setDisabled(true);
    try {
      final result = await _apiService.signUp(
          firstname: firstname,
          lastname: lastname,
          phoneNumber: phoneNumber,
          email: email,
          password: password,
          role: groupValue);
      setDisabled(false);
      showSnackbar("Success", result);
      Get.toNamed("/register-verification");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  void logoutRequest() {
    showLogoutDialog();
  }

  void logout() {
    userData.delete("accessToken");
    Get.offAllNamed("/sign-in");
    // userData.delete("user");
  }
}
