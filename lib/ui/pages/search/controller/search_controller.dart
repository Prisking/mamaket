import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/services/api_service.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';

class SearchController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  static Box userData = Hive.box("userData");

  static final User user = userData.get("user");
  final String accessToken = userData.get("accessToken");

  bool isLoading = false;
  String query;

  //pagination
  bool fetchingMore = false;
  bool hasReachexMax = false;

  List<PopulatedProduct> _results = [];

  List<PopulatedProduct> get results {
    return [..._results];
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setFetchingMore(bool fetching) {
    fetchingMore = fetching;
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

  void search(String query, List<double> geometry) async {
    setLoading(true);
    try {
      final result = await _apiService.searchproducts(
        longitude: geometry[0],
        latitude: geometry[1],
        query: query,
        accessToken: accessToken,
      );
      _results = result;
      setLoading(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoading(false);
    }
  }

  getMore(String query, List<double> geometry) async {
    setFetchingMore(true);
    if (hasReachexMax) {
      setFetchingMore(false);
      return;
    }
    try {
      final result = await _apiService.getMoreSearchResults(
        longitude: geometry[0],
        latitude: geometry[1],
        query: query,
        cursor: _results.last.sId,
        accessToken: accessToken,
      );
      if (result.length == 0) {
        hasReachexMax = true;
      }
      setFetchingMore(false);
      _results = _results + result;
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setFetchingMore(false);
    }
  }
}
