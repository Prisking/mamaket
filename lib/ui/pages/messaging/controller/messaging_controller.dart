import 'package:dash_chat/dash_chat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/services/api_service.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/messaging/models/conversation_model.dart';

import '../delivery_screen.dart';

class MessagingController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  static Box userData = Hive.box("userData");
  static final User user = userData.get("user");
  final String accessToken = userData.get("accessToken");

  bool isLoading = false;
  bool isDisabled = false;

  String deliveryBuyer;
  String deliverySeller;
  String deliveryProduct;

  List<Conversation> _conversations = [];

  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages {
    return [..._messages];
  }

  List<Conversation> get conversations {
    return [..._conversations];
  }

  int unreadCount = 0;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setDisabled(bool disabled) {
    isDisabled = disabled;
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

  void showBottomsheet({String buyer, String product, String seller}) {
    deliveryProduct = product;
    deliverySeller = seller;
    deliveryBuyer = buyer;

    Get.bottomSheet(
      DeliveryForm(),
      ignoreSafeArea: true,
    );
  }

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void setMessagesToEmpty() {
    _messages = [];
    notifyListeners();
  }

  void setUnreadCount() {
    unreadCount = 0;
    notifyListeners();
  }

  loadMessagesFromConversation({String conversationId}) async {
    setMessagesToEmpty();
    setUnreadCount();
    try {
      final result = await _apiService.loadMessagesFromConversation(
        conversationId: conversationId,
        accessToken: accessToken,
      );

      _messages = result.reversed
          .map(
            (e) => ChatMessage(
              id: e.sId,
              text: e.text,
              user: ChatUser(
                name: e.sender.name,
                avatar: e.sender.image,
                uid: e.sender.sId,
              ),
              createdAt: DateTime.parse(e.createdAt),
            ),
          )
          .toList();
      setLoading(false);
      this.getConversations();
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoading(false);
    }
  }

  initConversation({String sellerId, String productId}) async {
    setMessagesToEmpty();
    try {
      final result = await _apiService.initConversation(
          sellerId: sellerId, productId: productId, accessToken: accessToken);
      _messages = result
          .map(
            (e) => ChatMessage(
              id: e.sId,
              text: e.text,
              user: ChatUser(
                name: e.sender.name,
                avatar: e.sender.image,
                uid: e.sender.sId,
              ),
              createdAt: DateTime.parse(e.createdAt),
            ),
          )
          .toList();
      setLoading(false);
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoading(false);
    }
  }

  getConversations() async {
    setLoading(true);
    try {
      final List<Conversation> result =
          await _apiService.getConversations(accessToken: accessToken);
      _conversations = result.reversed.toList();
      setLoading(false);
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoading(false);
    }
  }

  getUnreadCount() async {
    try {
      final int result =
          await _apiService.getUnreadCount(accessToken: accessToken);
      unreadCount = result;
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        showError(e);
      } else {
        showSnackbar("Error", e.message);
      }
      setLoading(false);
    }
  }

  void sendDeliveryInfo({
    String deliveryCompany,
    String deliveryContactName,
    String price,
    String deliveryContactNumber,
  }) async {
    setDisabled(true);
    try {
      final _ = await _apiService.sendDeliveryInfo(
        deliveryCompany: deliveryCompany,
        deliveryContactName: deliveryContactName,
        price: price,
        deliveryContactNumber: deliveryContactNumber,
        seller: deliverySeller,
        buyer: deliveryBuyer,
        product: deliveryProduct,
        accessToken: accessToken,
      );

      setDisabled(false);
      showSnackbar("Success", "Successfully sent information to buyer");
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
}
