import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/messaging/models/chat.dart';
import 'package:mamaket/ui/pages/messaging/models/notification.dart';
import 'package:mamaket/ui/pages/messaging/widgets/tips_container.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'controller/messaging_controller.dart';

class NotificationChat extends StatefulWidget {
  final NotificationMod notificationModel;

  NotificationChat(this.notificationModel);
  @override
  _NotificationChatState createState() => _NotificationChatState();
}

class _NotificationChatState extends State<NotificationChat> {
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
        messagingController.loadMessagesFromConversation(
          conversationId: widget.notificationModel.conversationId,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
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
          createdAt: DateTime.parse(data['createdAt']).toLocal(),
          user: ChatUser(
            uid: data['sender']['_id'],
            name: data['sender']['name'],
            avatar: data['sender']['image'],
          ),
        );
        Future.delayed(Duration.zero, () {
          final messageController = Provider.of<MessagingController>(
            context,
            listen: false,
          );
          messageController.addMessage(message);
          messageController.getConversations();
          messageController.getUnreadCount();
        });
      },
    );
  }

  _sendMessage(message) {
    Provider.of<MessagingController>(
      context,
      listen: false,
    ).addMessage(message);

    final receiver = widget.notificationModel.participants
        .singleWhere((element) => element.id != user.id)
        .id;
    final data = ChatMessageDto(
      receiver: receiver,
      text: message.text,
      createdAt: message.createdAt.toString(),
      sender: Sender(id: message.user.uid, name: message.user.name),
      refProduct: widget.notificationModel.refProduct,
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
    final receiverName = widget.notificationModel.participants
        .singleWhere((element) => element.id != user.id)
        .name;
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverName),
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
          builder: (context, chat, child) => Column(
            children: <Widget>[
              TipsContainer(),
              Expanded(
                child: DashChat(
                  key: _chatViewKey,
                  messages: chat.messages,
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
