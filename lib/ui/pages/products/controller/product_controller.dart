import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/services/api_service.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/products/models/category_model.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:mamaket/ui/pages/products/models/product_model.dart';
import 'package:mamaket/ui/pages/products/models/rating_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final picker = ImagePicker();

  bool isLoading = false;
  bool isLoadingProducts = false;
  bool isDisabled = false;
  bool isUploading = false;
  bool isLoadingProduct = false;
  bool isInit = true;
  bool isInitBookmarked = true;

  double sellerRating = 0.0;
  int numRating = 0;

  //pagination for products
  bool fetchingMore = false;
  bool hasReachexMax = false;

  //Add Product
  String selectedCategoryId;
  List<String> selectedImages = [];
  List<String> tags = [];
  bool negotiable = false;
  String productSaleType;
  double startValue;
  double endValue;
  String selectedArea = "";

  //List of Categories
  List<Category> _categories = [];

  List<PopulatedProduct> _productsForCategory = [];

  List<PopulatedProduct> _trendingProducts = [];

  //List of Bookmarked Products
  List<PopulatedProduct> _bookmarkedProducts = [];

  List<PopulatedProduct> _productsForSeller = [];

  List<PopulatedProduct> _sponsoredForSeller = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<PopulatedProduct> get productsForCategory {
    return [..._productsForCategory];
  }

  List<PopulatedProduct> get trendingProducts {
    return [..._trendingProducts];
  }

  List<PopulatedProduct> get bookmarkedProducts {
    return [..._bookmarkedProducts];
  }

  List<PopulatedProduct> get productsForSeller {
    return [..._productsForSeller];
  }

  List<PopulatedProduct> get sponsoredForSeller {
    return [..._sponsoredForSeller];
  }

  void setEditingProduct(PopulatedProduct product) {
    selectedCategoryId = product.categoryId;
    selectedImages = product.images;
    tags = product.tags;
    negotiable = product.negotiable;
    productSaleType = product.productSaleType;
  }

  static Box userData = Hive.box("userData");

  static final User user = userData.get("user");
  final String accessToken = userData.get("accessToken");

  void setDisabled(bool disabled) {
    isDisabled = disabled;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setLoadingProduct(bool loading) {
    isLoadingProduct = loading;
    notifyListeners();
  }

  void setLoadingProducts(bool loading) {
    isLoadingProducts = loading;
    notifyListeners();
  }

  void call(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void setCategoryId(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  void setProductSaleType(String value) {
    productSaleType = value;
    notifyListeners();
  }

  void setFetchingMore(bool fetching) {
    fetchingMore = fetching;
    notifyListeners();
  }

  void addTag(String tag) {
    tags.add(tag);
    notifyListeners();
  }

  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }

  void removeImage(String image) {
    selectedImages.remove(image);
    notifyListeners();
  }

  void setNegotiable(bool value) {
    negotiable = value;
    notifyListeners();
  }

  void setUploading(bool value) {
    isUploading = value;
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

  getCategories() async {
    setLoading(true);
    try {
      final result = await _apiService.getCategories(accessToken: accessToken);
      _categories = result;
      isInit = false;
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

  getProductsForCategory(String categoryId, List<double> geometry) async {
    setLoadingProducts(true);
    try {
      final List<PopulatedProduct> result =
          await _apiService.getProductsForCategory(
        longitude: geometry[0],
        latitude: geometry[1],
        categoryId: categoryId,
        accessToken: accessToken,
      );
      _productsForCategory = result;
      setLoadingProducts(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoadingProducts(false);
    }
  }

  getMoreProductsForCategory(String categoryId, List<double> geometry) async {
    setFetchingMore(true);
    if (hasReachexMax) {
      setFetchingMore(false);
      return;
    }
    if (startValue == null && endValue == null) {
      try {
        final result = await _apiService.getMoreProductsForCategory(
          longitude: geometry[0],
          latitude: geometry[1],
          categoryId: categoryId,
          cursor: _productsForCategory.last.sponsored,
          accessToken: accessToken,
        );
        if (result.length == 0) {
          hasReachexMax = true;
        }
        setFetchingMore(false);
        _productsForCategory = _productsForCategory + result;
        notifyListeners();
      } on DioError catch (e) {
        if (e.response != null) {
          showError(e);
        } else {
          showSnackbar("Error", e.message);
        }
        setFetchingMore(false);
      }
    } else {
      filterMoreProducts(categoryId);
    }
  }

  getProductsForSeller(String sellerId) async {
    setLoadingProducts(true);
    try {
      final List<PopulatedProduct> result =
          await _apiService.getProductsForSeller(
        sellerId: sellerId,
        accessToken: accessToken,
      );
      _productsForSeller = result;
      setLoadingProducts(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoadingProducts(false);
    }
  }

  getMoreProductsForSeller(String sellerId) async {
    setFetchingMore(true);
    if (hasReachexMax) {
      setFetchingMore(false);
      return;
    }
    try {
      final result = await _apiService.getMoreProductsForSeller(
        sellerId: sellerId,
        cursor: _productsForSeller.last.sId,
        accessToken: accessToken,
      );
      if (result.length == 0) {
        hasReachexMax = true;
      }
      setFetchingMore(false);
      _productsForSeller = _productsForSeller + result;
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

  getSponsoredProductsForSeller(String sellerId) async {
    setLoadingProducts(true);
    try {
      final List<PopulatedProduct> result =
          await _apiService.getSponsoredProductsForSeller(
        sellerId: sellerId,
        accessToken: accessToken,
      );
      _sponsoredForSeller = result;
      setLoadingProducts(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoadingProducts(false);
    }
  }

  getMoreSponsoredProductsForSeller(String sellerId) async {
    setFetchingMore(true);
    if (hasReachexMax) {
      setFetchingMore(false);
      return;
    }
    try {
      final result = await _apiService.getMoreSponsoredProductsForSeller(
        sellerId: sellerId,
        cursor: _sponsoredForSeller.last.sId,
        accessToken: accessToken,
      );
      if (result.length == 0) {
        hasReachexMax = true;
      }
      setFetchingMore(false);
      _sponsoredForSeller = _sponsoredForSeller + result;
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

  getBookmarkedProducts() async {
    setLoading(true);
    try {
      final List<PopulatedProduct> result =
          await _apiService.getBookmarkedProducts(accessToken: accessToken);
      _bookmarkedProducts = result;
      isInitBookmarked = false;
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

  getTrendingProducts(List<double> geometry) async {
    setLoadingProducts(true);
    try {
      final List<PopulatedProduct> result =
          await _apiService.getTrendingProducts(
        longitude: geometry[0],
        latitude: geometry[1],
        accessToken: accessToken,
      );
      _trendingProducts = result;
      setLoadingProducts(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoadingProducts(false);
    }
  }

  addProductView(PopulatedProduct product) async {
    if (user.id == product.sellerId.sId) {
      return;
    }
    try {
      final _ = await _apiService.addProductView(
        id: product.sId,
        accessToken: accessToken,
      );
    } on DioError catch (e) {
      print(e);
    }
  }

  void handlemageSource() {
    showImageSourceDialog();
  }

  void handlePickImage(String source) async {
    final pickedFile = await picker.getImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile.path == null) {
      return;
    }
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 60,
      compressFormat: ImageCompressFormat.jpg,
      maxWidth: 700,
      maxHeight: 700,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: kPrimaryColor,
        backgroundColor: Colors.black,
      ),
    );

    setUploading(true);
    try {
      final result = await _apiService.uploadProfileImage(croppedFile.path);
      selectedImages.add(result);
      setUploading(false);
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
      } else {
        showSnackbar("Error", e.message);
      }
      setUploading(false);
    }
  }

  createProduct(
    String name,
    String description,
    String quantity,
    String price,
  ) async {
    setDisabled(true);
    try {
      final Product result = await _apiService.createProduct(
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        images: selectedImages,
        categoryId: selectedCategoryId,
        negotiable: negotiable,
        tags: tags,
        productSaleType: productSaleType,
        accessToken: accessToken,
      );
      selectedImages = [];
      tags = [];
      negotiable = false;
      Get.toNamed("/upload-done", arguments: result);
      setDisabled(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  String formatPrice(int price) {
    final number = new NumberFormat("#,###", "en_NG");
    return "₦ ${number.format(price)}";
  }

  editProduct(String name, String description, String quantity, String price,
      String id) async {
    setDisabled(true);
    try {
      final Product _ = await _apiService.editProduct(
          name: name,
          description: description,
          quantity: quantity,
          price: price,
          images: selectedImages,
          categoryId: selectedCategoryId,
          negotiable: negotiable,
          tags: tags,
          productSaleType: productSaleType,
          accessToken: accessToken,
          id: id);
      selectedImages = [];
      tags = [];
      showSnackbar("Success", "Successfully edited product");
      setDisabled(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  initiateDelete(String id) {
    Get.dialog(
      AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete this product?"),
        actions: <Widget>[
          FlatButton(
            child: Text("YES"),
            onPressed: () {
              handleDeleteImage(id);
              Get.back();
            },
          ),
          FlatButton(
            child: Text("NO"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  handleDeleteImage(String id) async {
    setDisabled(true);
    try {
      final _ =
          await _apiService.deleteProduct(id: id, accessToken: accessToken);
      setDisabled(false);
      Get.back();
      showSnackbar("Success", "Successfully deleted product");
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  bookmarkProduct(String id) async {
    try {
      final result =
          await _apiService.bookmarkProduct(id: id, accessToken: accessToken);

      // userData.delete("bookmarkedProducts");
      userData.put("bookmarkedProducts", result);
      showSnackbar("Success", "Bookmark added successfully");
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  removeBookmark(String id) async {
    try {
      final result =
          await _apiService.removeBookmark(id: id, accessToken: accessToken);
      // userData.delete("bookmarkedProducts");
      userData.put("bookmarkedProducts", result);
      showSnackbar("Success", "Bookmark has been removed");
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
    }
  }

  Future<double> getMaxPrice() async {
    try {
      final result = await _apiService.getMaxPrice(accessToken: accessToken);

      final firstResult = result[0];
      final doubleResult = firstResult.price.toDouble();
      return doubleResult;
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setDisabled(false);
      return 10000;
    }
  }

  void filter(startValue, endValue, selectedArea, String categoryId) async {
    this.startValue = startValue;
    this.endValue = endValue;
    this.selectedArea = selectedArea;
    setLoadingProducts(true);
    try {
      final result = await _apiService.filter(
          startValue: startValue,
          endValue: endValue,
          selectedArea: selectedArea,
          accessToken: accessToken,
          categoryId: categoryId);
      _productsForCategory = result;
      setLoadingProducts(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoadingProducts(false);
    }
  }

  filterMoreProducts(String categoryId) async {
    try {
      final result = await _apiService.filterMoreProducts(
          categoryId: categoryId,
          cursor: _productsForCategory.last.sId,
          accessToken: accessToken,
          startValue: startValue,
          endValue: endValue,
          selectedArea: selectedArea);
      if (result.length == 0) {
        hasReachexMax = true;
      }
      setFetchingMore(false);
      _productsForCategory = _productsForCategory + result;
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

  getRating(String sellerId) async {
    setLoadingProduct(true);
    try {
      final List<Rating> result =
          await _apiService.getRating(sellerId: sellerId);
      if (result.length == 0) {
        sellerRating = 0;
        numRating = 0;
      } else {
        final data = result.first;
        sellerRating = data.avgRating;
        numRating = data.numRating;
      }

      setLoadingProduct(false);
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoadingProduct(false);
    }
  }
}
