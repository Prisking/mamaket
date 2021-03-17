import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/services/api_service.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/payment/models/transaction_model.dart';

class PaymentController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool busy = false;
  static Box userData = Hive.box("userData");

  static final User user = userData.get("user");
  final String accessToken = userData.get("accessToken");

  // type and amount
  int amount = 1500;
  int type = 1;

  void setBusy(bool value) {
    busy = value;
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

  void setTypeAndAmount(int type, int amount) {
    this.type = type;
    this.amount = amount;
    notifyListeners();
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

  Future<Transaction> initializeTransaction(String product) async {
    setBusy(true);
    try {
      final Transaction result = await _apiService.initializeTransaction(
        amount: amount,
        sponsoredType: type,
        product: product,
        accessToken: accessToken,
      );
      setBusy(false);
      return result;
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setBusy(false);
      return null;
    }
  }
}
