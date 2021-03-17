import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/messaging/models/chat.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'controller/messaging_controller.dart';
import 'widgets/tips_container.dart';

class NewChat extends StatefulWidget {
  final PopulatedProduct product;
  NewChat(this.product);
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  static Box userData = Hive.box("userData");
  final User user = userData.get("user");

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  Socket socket;
  @override
  void initState() {
    super.initState();
    socket = io(kBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'user': user.id}
    });
    socket.connect();
    Future.delayed(
      Duration.zero,
      () {
        final messagingController =
            Provider.of<MessagingController>(context, listen: false);
        messagingController.initConversation(
            sellerId: widget.product.sellerId.sId,
            productId: widget.product.sId);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socket.on(
      'msgToClient',
      (data) {
        final message = ChatMessage(
          text: data['text'],
          id: data['_id'],
          createdAt: DateTime.parse(data['createdAt']),
          user: ChatUser(
            uid: data['sender']['_id'],
            name: data['sender']['name'],
            avatar: data['sender']['image'],
          ),
        );
        Future.delayed(
          Duration.zero,
          () {
            final messageController = Provider.of<MessagingController>(
              context,
              listen: false,
            );
            messageController.addMessage(message);
            messageController.getConversations();
            messageController.getUnreadCount();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  _sendMessage(ChatMessage message) {
    Provider.of<MessagingController>(context, listen: false)
        .addMessage(message);

    final data = ChatMessageDto(
      receiver: widget.product.sellerId.sId,
      text: message.text,
      createdAt: message.createdAt.toString(),
      sender: Sender(id: message.user.uid, name: message.user.name),
      refProduct: widget.product.sId,
    );

    final messageToServer = data.toJson();
    socket.emit("msgToServer", messageToServer);
    final messageProvider = Provider.of<MessagingController>(
      context,
      listen: false,
    );

    messageProvider.getConversations();
    messageProvider.getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.sellerId.name),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.local_shipping_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/tips-screen");
            },
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<MessagingController>(
          builder: (context, messagingController, child) => Column(
            children: <Widget>[
              TipsContainer(),
              Expanded(
                child: DashChat(
                  key: _chatViewKey,
                  messages: messagingController.messages,
                  user: ChatUser(
                    name: user.name,
                    uid: user.id,
                    avatar: user.image,
                  ),
                  onSend: _sendMessage,
                  sendOnEnter: true,
                  inputCursorColor: kPrimaryColor,
                  inputDecoration: InputDecoration(
                    hintText: "Message",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  inputContainerStyle: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.5, color: Colors.grey[200]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
