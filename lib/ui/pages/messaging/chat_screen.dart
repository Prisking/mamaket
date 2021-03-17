import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/messaging/models/chat.dart';
import 'package:mamaket/ui/pages/messaging/models/conversation_model.dart';
import 'package:mamaket/ui/pages/messaging/widgets/tips_container.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'controller/messaging_controller.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  ChatScreen(this.conversation);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
          conversationId: widget.conversation.sId,
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

    final receiver = widget.conversation.participants
        .singleWhere((element) => element.sId != user.id)
        .sId;
    final data = ChatMessageDto(
      receiver: receiver,
      text: message.text,
      createdAt: message.createdAt.toString(),
      sender: Sender(id: message.user.uid, name: message.user.name),
      refProduct: widget.conversation.refProduct,
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
    final receiver = widget.conversation.participants
        .singleWhere((element) => element.sId != user.id);

    final messageController = Provider.of<MessagingController>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.name),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        actions: user.role == "seller"
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.local_shipping_outlined, color: Colors.white),
                  onPressed: () {
                    messageController.showBottomsheet(
                      seller: user.id,
                      buyer: receiver.sId,
                      product: widget.conversation.refProduct,
                    );
                  },
                )
              ]
            : null,
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
