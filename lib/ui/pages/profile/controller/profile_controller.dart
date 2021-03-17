import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/services/api_service.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/products/models/rating_model.dart';
import 'package:mamaket/ui/pages/profile/models/area.dart';
import 'package:mamaket/ui/pages/profile/models/city.dart';
import 'package:mamaket/ui/pages/profile/models/profile.dart';

class ProfileController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  Location location = new Location();
  final picker = ImagePicker();

  bool isDisabled = false;
  bool isUploading = false;
  bool isLoading = false;
  bool rateLoading = false;
  bool showPassword = false;
  static Box userData = Hive.box("userData");

  static final User user = userData.get("user");
  final String accessToken = userData.get("accessToken");

  //location
  bool serviceEnabled;
  PermissionStatus permissionStatus;
  double _latitude;
  double _longitude;
  Address _address;

  //location getters
  List<double> get currentPosition {
    return [_longitude, _latitude];
  }

  Address get address {
    return _address;
  }

  //Region Update
  List<City> cities = [];
  List<Area> areas = [];
  String selectedCity;
  String selectedArea;
  double _regionLatitude;
  double _regionLongitude;

  //Radio
  String groupValue = user.role;
  String imageUrl;

  //Profile

  Profile profile;
  IsRated isRated;
  int rating = 0;
  double newRating;

  void setDisabled(bool disabled) {
    isDisabled = disabled;
    notifyListeners();
  }

  void setCurrentGroupValue(value) {
    groupValue = value;
  }

  void setUploading(bool value) {
    isUploading = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
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

  void getCities() async {
    setLoading(true);
    try {
      final List<City> result = await _apiService.getCities();
      cities = result;
      notifyListeners();
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

  void setCity(String city) {
    selectedCity = city;
    notifyListeners();
    getAreasForCity(city);
  }

  void getAreasForCity(String city) async {
    try {
      final List<Area> result = await _apiService.getAreasForCity(city: city);
      areas = result;

      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
    }
  }

  void setAreaAndLatLng(area) {
    final Area found = areas.singleWhere((value) => value.name == area);

    selectedArea = area;
    _regionLatitude = found.latitude;
    _regionLongitude = found.longitude;
    notifyListeners();
  }

  void updateUserRegion() async {
    setDisabled(true);
    try {
      final User result = await _apiService.updateUserRegion(
        accessToken: accessToken,
        type: 'Point',
        longitude: _regionLongitude,
        latitude: _regionLatitude,
        region: selectedArea,
      );
      userData.put("user", result);
      setDisabled(false);
      showSnackbar("Success", "Your profile was updated successfully");

      Get.back();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Select Image From"),
        actions: <Widget>[
          FlatButton(
            child: Text("CAMERA"),
            onPressed: () {
              handlePickImage("camera");
              Get.back();
            },
          ),
          FlatButton(
            child: Text("GALLERY"),
            onPressed: () {
              handlePickImage("gallery");
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void showProgressDialog() {
    Get.dialog(
      AlertDialog(
        content: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  changePassword(String oldPassword, String newPassword) async {
    setDisabled(true);
    try {
      final _ = await _apiService.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
          accessToken: accessToken);
      setDisabled(false);
      showSnackbar("Success", "Your password was changed successfully");
      Get.back();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  updateProfile(String firstname, String lastname, String phoneNumber) async {
    setDisabled(true);
    try {
      final result = await _apiService.updateProfile(
        firstname: firstname,
        lastname: lastname,
        phoneNumber: phoneNumber,
        role: groupValue,
        accessToken: accessToken,
        image: imageUrl,
      );
      userData.put("user", result);
      setDisabled(false);
      showSnackbar("Success", "Your profile was updated successfully");
      Get.back();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  void handlemageSource() {
    showImageSourceDialog();
  }

  void handlePickImage(String source) async {
    final pickedFile = await picker.getImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile.path == null) {
      return;
    }
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 60,
      compressFormat: ImageCompressFormat.jpg,
      maxWidth: 300,
      maxHeight: 300,
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: kPrimaryColor,
        backgroundColor: Colors.black,
      ),
    );

    setUploading(true);
    try {
      final result = await _apiService.uploadProfileImage(croppedFile.path);
      imageUrl = result;
      updateUserImage(result);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
      } else {
        showSnackbar("Error", e.message);
      }
      setUploading(false);
    }
  }

  void updateUserImage(String url) async {
    try {
      final result = await _apiService.updateUserImage(
        accessToken: accessToken,
        image: url,
      );
      userData.put("user", result);
      setUploading(false);
      showSnackbar("Success", "Your profile picture was updated successfully");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setUploading(false);
    }
  }

  initializeLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled) {
      print("Service Enabled $serviceEnabled");
      checkPermissions();
    } else {
      requestService();
    }
  }

  requestService() async {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      //Manual
      return;
    }
    checkPermissions();
  }

  checkPermissions() async {
    permissionStatus = await location.hasPermission();
    print("Check $permissionStatus");
    if (permissionStatus == PermissionStatus.granted) {
      getCurrentLocation();
    } else {
      requestPermission();
    }
  }

  requestPermission() async {
    permissionStatus = await location.requestPermission();
    print(permissionStatus);
    if (permissionStatus == PermissionStatus.granted) {
      getCurrentLocation();
    } else {
      //Manual
      print("Permission not Granted at Request $permissionStatus");
    }
  }

  getCurrentLocation() async {
    LocationData locationData = await location.getLocation();
    print(locationData);
    _longitude = locationData.longitude;
    _latitude = locationData.latitude;
    notifyListeners();
    // getPlacemarkFromPosition();
  }

  getPlacemarkFromPosition() async {
    final coordinates = new Coordinates(_latitude, _longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
  }

  getUser(String id) async {
    setLoading(true);
    try {
      final result = await _apiService.getUserProfile(id: id);
      profile = result;
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoading(false);
    }
  }

  getIsRated(String sellerId) async {
    newRating = null;
    try {
      final result = await _apiService.getIsRated(
          sellerId: sellerId, accessToken: accessToken);
      if (result == null) {
        rating = 0;
      } else {
        rating = result.rating;
      }
      isRated = result;
      setLoading(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
    }
  }

  void setRateLoading(bool value) {
    rateLoading = value;
    notifyListeners();
  }

  void setNewRating(double value) {
    newRating = value;
    rating = value.toInt();
    notifyListeners();
  }

  rateSeller(String sellerId) async {
    setRateLoading(true);
    try {
      final result = await _apiService.rateSeller(
        accessToken: accessToken,
        sellerId: sellerId,
        rating: newRating.toInt(),
      );
      rating = result.rating;
      isRated = result;
      setRateLoading(false);
      showSnackbar("Success", "Your rating was submitted successfully");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setRateLoading(false);
    }
  }

  editRating() async {
    setRateLoading(true);
    try {
      final result = await _apiService.editRating(
        accessToken: accessToken,
        id: isRated.sId,
        rating: newRating.toInt(),
      );
      rating = result.rating;
      isRated = result;
      setRateLoading(false);
      showSnackbar("Success", "Your rating was submitted successfully");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setRateLoading(false);
    }
  }

  // Navigator.pushAndRemoveUntil(newRoute, (route)=>false);
}
