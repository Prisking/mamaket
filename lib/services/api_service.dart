import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/messaging/models/conversation_model.dart';
import 'package:mamaket/ui/pages/messaging/models/delivery.dart';
import 'package:mamaket/ui/pages/messaging/models/message_model.dart';
import 'package:mamaket/ui/pages/payment/models/transaction_model.dart';
import 'package:mamaket/ui/pages/products/models/category_model.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:mamaket/ui/pages/products/models/product_model.dart';
import 'package:mamaket/ui/pages/products/models/rating_model.dart';
import 'package:mamaket/ui/pages/profile/models/area.dart';
import 'package:mamaket/ui/pages/profile/models/city.dart';
import 'package:mamaket/ui/pages/profile/models/profile.dart';

class ApiService {
  static BaseOptions options = new BaseOptions(
    baseUrl: kBaseUrl,
  );
  Dio dio = new Dio(options);

  //Sign In
  Future<User> signIn({
    @required String email,
    @required String password,
    String fcmToken,
  }) async {
    Response response = await dio.post("/auth/login",
        data: {"email": email, "password": password, "fcmToken": fcmToken});
    final payload = User.fromJson(response.data);

    return payload;
  }

  //Sign Up
  Future signUp(
      {@required String firstname,
      @required String lastname,
      @required String phoneNumber,
      @required String email,
      @required String password,
      @required String role}) async {
    Response response = await dio.post(
      "/auth/signup",
      data: {
        "name": "$firstname $lastname",
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
        "role": role
      },
    );
    final message = response.data["success"];
    return message;
  }

  //Forgot Password
  Future forgotPassword({@required String email}) async {
    Response response = await dio.post("/auth/forgot", data: {"email": email});

    final message = response.data["success"];
    return message;
  }

  // Confirm Email
  Future confirmEmail({@required String token}) async {
    Response response = await dio.get("/auth/confirm/$token");
    final message = response.data["success"];
    return message;
  }

  // Request Reset Password Code
  Future requestReset({@required String token}) async {
    Response response = await dio.get("/auth/reset/$token");
    final message = response.data["success"];
    return message;
  }

  // Reset Password
  Future resetPassword({
    @required String password,
    @required String password2,
    @required String token,
  }) async {
    Response response = await dio.post(
      "/auth/reset/$token",
      data: {"password": password, "password2": password2},
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  // Change Password
  Future changePassword({
    @required String oldPassword,
    @required String newPassword,
    @required String accessToken,
  }) async {
    Response response = await dio.post(
      "/auth/change-password",
      data: {"oldPassword": oldPassword, "newPassword": newPassword},
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  // Update Profile
  Future updateProfile({
    @required String firstname,
    @required String lastname,
    @required String phoneNumber,
    @required String role,
    @required String accessToken,
    @required String image,
  }) async {
    Response response = await dio.put(
      "/profile",
      data: {
        "name": "$firstname $lastname",
        "phoneNumber": phoneNumber,
        "role": role
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  // Get Categories
  Future<List<Category>> getCategories({@required String accessToken}) async {
    Response response = await dio.get(
      "/category",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((category) => Category.fromJson(category));
    return data.toList();
  }

  // Get Bookmarked Products
  Future<List<PopulatedProduct>> getBookmarkedProducts(
      {@required String accessToken}) async {
    Response response = await dio.get(
      "/product/bookmarked",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  // Upload Profile Image
  Future<String> uploadProfileImage(String path) async {
    FormData formData = new FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(
          path,
        ),
        "upload_preset": "profile",
        "cloud_name": "mamarket",
      },
    );
    Response response = await dio.post(
      "https://api.cloudinary.com/v1_1/mamarket/upload",
      data: formData,
    );

    final url = response.data['secure_url'];
    return url;
  }

  // Initialize Transaction
  Future initializeTransaction({
    @required int amount,
    @required String product,
    @required int sponsoredType,
    @required String accessToken,
  }) async {
    Response response = await dio.post(
      "/payment/initialize",
      data: {
        "amount": amount * 100,
        "product": product,
        "sponsoredType": sponsoredType
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    print(response.data);
    final data = Transaction.fromJson(response.data['data']);
    return data;
  }

  // Update User Image
  Future updateUserImage({
    @required String accessToken,
    @required String image,
  }) async {
    Response response = await dio.put(
      "/profile",
      data: {
        "image": image,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  // Create Product
  Future createProduct({
    @required String name,
    @required String description,
    @required String price,
    @required String quantity,
    @required String categoryId,
    @required List<String> images,
    @required List<String> tags,
    @required String productSaleType,
    @required bool negotiable,
    @required String accessToken,
  }) async {
    Response response = await dio.post(
      "/product",
      data: {
        "name": name,
        "description": description,
        "price": price,
        "quantity": quantity,
        "categoryId": categoryId,
        "images": images,
        "tags": tags,
        "productSaleType": productSaleType,
        "negotiable": negotiable,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = Product.fromJson(response.data);
    return payload;
  }

  Future editProduct(
      {@required String name,
      @required String description,
      @required String price,
      @required String quantity,
      @required String categoryId,
      @required List<String> images,
      @required List<String> tags,
      @required String productSaleType,
      @required bool negotiable,
      @required String accessToken,
      @required String id}) async {
    Response response = await dio.put(
      "/product/$id/update",
      data: {
        "name": name,
        "description": description,
        "price": price,
        "quantity": quantity,
        "categoryId": categoryId,
        "images": images,
        "tags": tags,
        "productSaleType": productSaleType,
        "negotiable": negotiable,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = Product.fromJson(response.data);
    return payload;
  }

  //Get Cities
  Future<List<City>> getCities() async {
    Response response = await dio.get(
      "/geocoding/cities",
    );
    final payload = response.data as List;
    final data = payload.map((city) => City.fromJson(city));
    return data.toList();
  }

  //Get Areas for City
  Future<List<Area>> getAreasForCity({@required String city}) async {
    Response response = await dio.get(
      "/geocoding/areas?city=$city",
    );
    final payload = response.data as List;
    final data = payload.map((area) => Area.fromJson(area));
    return data.toList();
  }

  //Update Seller Region
  Future updateUserRegion({
    @required String accessToken,
    @required String type,
    @required double longitude,
    @required double latitude,
    @required String region,
  }) async {
    Response response = await dio.put(
      "/profile/geometry",
      data: {
        "type": type,
        "longitude": longitude,
        "latitude": latitude,
        "region": region,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  //Get Products for Category
  Future<List<PopulatedProduct>> getProductsForCategory({
    @required double longitude,
    @required double latitude,
    @required String categoryId,
    @required String accessToken,
  }) async {
    var latToSend = latitude == null ? "" : latitude;
    var lngToSend = longitude == null ? "" : longitude;
    Response response = await dio.get(
      "/product?categoryId=$categoryId&longitude=$lngToSend&latitude=$latToSend",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Get More Products for Category
  Future<List<PopulatedProduct>> getMoreProductsForCategory({
    double longitude,
    double latitude,
    String categoryId,
    String cursor,
    String accessToken,
  }) async {
    var latToSend = latitude == null ? "" : latitude;
    var lngToSend = longitude == null ? "" : longitude;
    Response response = await dio.get(
      "/product?categoryId=$categoryId&longitude=$lngToSend&latitude=$latToSend&cursor=$cursor",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Search Products
  Future<List<PopulatedProduct>> searchproducts({
    @required double longitude,
    @required double latitude,
    @required String query,
    @required String accessToken,
  }) async {
    var latToSend = latitude == null ? "" : latitude;
    var lngToSend = longitude == null ? "" : longitude;
    Response response = await dio.get(
      "/product/search/$query?longitude=$lngToSend&latitude=$latToSend",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

//Get More Search Results
  Future<List<PopulatedProduct>> getMoreSearchResults({
    double longitude,
    double latitude,
    String query,
    String cursor,
    String accessToken,
  }) async {
    var latToSend = latitude == null ? "" : latitude;
    var lngToSend = longitude == null ? "" : longitude;
    Response response = await dio.get(
      "/product/search/$query?longitude=$lngToSend&latitude=$latToSend&cursor=$cursor",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;

    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Get Trending Products
  Future<List<PopulatedProduct>> getTrendingProducts({
    @required double longitude,
    @required double latitude,
    @required String accessToken,
  }) async {
    Response response = await dio.get(
      "/product/trending?longitude=$longitude&latitude=$latitude",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Get More Trending Products
  Future<List<PopulatedProduct>> getMoreTrendingProducts({
    @required double longitude,
    @required double latitude,
    @required String accessToken,
    @required String cursor,
  }) async {
    Response response = await dio.get(
      "/product/trending?longitude=$longitude&latitude=$latitude&cursor=$cursor",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Get Products for Seller
  Future<List<PopulatedProduct>> getProductsForSeller({
    @required String sellerId,
    @required String accessToken,
  }) async {
    Response response = await dio.get(
      "/product/seller/$sellerId",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Get More Products for Seller
  Future<List<PopulatedProduct>> getMoreProductsForSeller({
    @required String sellerId,
    @required String accessToken,
    @required String cursor,
  }) async {
    Response response = await dio.get(
      "/product/seller/$sellerId?cursor=$cursor",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  Future<List<PopulatedProduct>> getSponsoredProductsForSeller({
    @required String sellerId,
    @required String accessToken,
  }) async {
    Response response = await dio.get(
      "/product/seller/sponsored/$sellerId",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Get More Products for Seller
  Future<List<PopulatedProduct>> getMoreSponsoredProductsForSeller({
    @required String sellerId,
    @required String accessToken,
    @required String cursor,
  }) async {
    Response response = await dio.get(
      "/product/seller/sponsored/$sellerId?cursor=$cursor",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  //Add Product View
  Future<Product> addProductView({
    @required String id,
    @required String accessToken,
  }) async {
    Response response = await dio.put(
      "/product/view/$id",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = Product.fromJson(response.data);
    return payload;
  }

  Future<List<Message>> initConversation({
    @required String sellerId,
    @required String productId,
    @required String accessToken,
  }) async {
    Response response = await dio.get(
      "/chat/init-conversation?sellerId=$sellerId&productId=$productId",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((message) => Message.fromJson(message));
    return data.toList();
  }

  Future<List<Conversation>> getConversations({
    @required String accessToken,
  }) async {
    Response response = await dio.get(
      "/chat/list",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((message) => Conversation.fromJson(message));
    return data.toList();
  }

  Future<List<Message>> loadMessagesFromConversation({
    @required String conversationId,
    @required String accessToken,
  }) async {
    Response response = await dio.get(
      "/chat/load-messages?conversation=$conversationId",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((message) => Message.fromJson(message));
    return data.toList();
  }

  Future<Product> deleteProduct({
    @required String id,
    @required accessToken,
  }) async {
    Response response = await dio.put("/product/archive/$id",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}));

    final payload = Product.fromJson(response.data);
    return payload;
  }

  Future<List<String>> bookmarkProduct({
    @required String id,
    @required String accessToken,
  }) async {
    Response response = await dio.put("/product/bookmark/$id",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}));
    final payload = response.data as List;
    final data = payload.map((e) => e.toString()).toList();
    return data;
  }

  Future<List<String>> removeBookmark({
    @required String id,
    @required String accessToken,
  }) async {
    Response response = await dio.put("/product/bookmark/remove/$id",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}));
    final payload = response.data as List;
    final data = payload.map((e) => e.toString()).toList();
    return data;
  }

  Future<List<Product>> getMaxPrice({@required String accessToken}) async {
    Response response = await dio.get(
      "/product/maximum/product",
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );

    final payload = response.data as List;
    final data = payload.map((product) => Product.fromJson(product));
    return data.toList();
  }

  Future<List<PopulatedProduct>> filter({
    @required double startValue,
    @required double endValue,
    @required String selectedArea,
    @required String accessToken,
    @required String categoryId,
  }) async {
    final area = selectedArea == null ? "" : selectedArea;
    Response response = await dio.get(
      "/product/filters/prod?startPrice=$startValue&endPrice=$endValue&region=$area&categoryId=$categoryId",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  Future<List<PopulatedProduct>> filterMoreProducts(
      {@required double startValue,
      @required double endValue,
      @required String selectedArea,
      @required String accessToken,
      @required String cursor,
      @required String categoryId}) async {
    final area = selectedArea == null ? "" : selectedArea;
    Response response = await dio.get(
      "/product/filters/prod?startPrice=$startValue&endPrice=$endValue&region=$area&categoryId=$categoryId&cursor=$cursor",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    final payload = response.data as List;
    final data = payload.map((product) => PopulatedProduct.fromJson(product));
    return data.toList();
  }

  Future<int> getUnreadCount({@required String accessToken}) async {
    Response response = await dio.get(
      "/chat/unread-count",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    final payload = int.parse(response.data);
    return payload;
  }

  Future<List<Rating>> getRating({@required String sellerId}) async {
    Response response = await dio.get("/rating?sellerId=$sellerId");

    final payload = response.data as List;
    final data = payload.map((rating) => Rating.fromJson(rating));
    return data.toList();
  }

  Future<Profile> getUserProfile({@required String id}) async {
    Response response = await dio.get("/profile/$id");

    final payload = response.data;
    final data = Profile.fromJson(payload);
    return data;
  }

  Future<IsRated> getIsRated(
      {@required String sellerId, @required String accessToken}) async {
    Response response = await dio.get(
      "/rating/check?sellerId=$sellerId",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );

    final payload = response.data;
    if (payload is String) {
      return null;
    } else {
      final data = IsRated.fromJson(payload);
      return data;
    }
  }

  Future<IsRated> rateSeller({
    @required String accessToken,
    @required String sellerId,
    @required int rating,
  }) async {
    Response response = await dio.post(
      "/rating/rate",
      data: {
        "sellerId": sellerId,
        "rating": rating,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    final payload = response.data;
    final data = IsRated.fromJson(payload);
    return data;
  }

  Future<IsRated> editRating({
    @required String accessToken,
    @required String id,
    @required int rating,
  }) async {
    Response response = await dio.put(
      "/rating/edit/$id",
      data: {
        "rating": rating,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    final payload = response.data;
    final data = IsRated.fromJson(payload);
    return data;
  }

  Future sendDeliveryInfo({
    @required String deliveryCompany,
    @required String deliveryContactName,
    @required String price,
    @required String deliveryContactNumber,
    @required String seller,
    @required String buyer,
    @required String product,
    @required String accessToken,
  }) async {
    Response response = await dio.post(
      "/delivery/create",
      data: {
        "deliveryCompany": deliveryCompany,
        "deliveryContactName": deliveryContactName,
        "price": price,
        "deliveryContactNumber": deliveryContactNumber,
        "seller": seller,
        "buyer": buyer,
        "product": product,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    final payload = response.data;
    final data = Delivery.fromJson(payload);
    return data;
  }
}
