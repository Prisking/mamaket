import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/messaging/models/conversation_model.dart';
import 'package:provider/provider.dart';

import 'controller/messaging_controller.dart';

class Conversations extends StatefulWidget {
  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  static Box userData = Hive.box("userData");
  final User user = userData.get("user");
  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () {
        final messagingController =
            Provider.of<MessagingController>(context, listen: false);
        messagingController.getConversations();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagingController = Provider.of<MessagingController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Messages"),
        centerTitle: true,
      ),
      body: _buildBody(messagingController),
    );
  }

  Widget _buildBody(MessagingController messagingController) {
    if (messagingController.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!messagingController.isLoading &&
        messagingController.conversations.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No Data"),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => messagingController.getConversations(),
      child: ListView.builder(
        itemCount: messagingController.conversations.length,
        itemBuilder: (context, int index) {
          final item = messagingController.conversations[index];
          final receiver = item.latestMessage.receiver;
          final read = item.latestMessage.read;
          return Container(
            color: receiver == user.id && read == false
                ? kLightBlue
                : Colors.white,
            child: ListTile(
              onTap: () {
                Get.toNamed('/chat-screen', arguments: item);
              },
              leading: _buildAvatar(item),
              title: Text(
                _setConversationName(item),
                style: TextStyle(color: kPrimaryColor, fontSize: 20),
              ),
              subtitle: Text(item.latestMessage.text),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    _renderDate(
                      item.latestMessage.createdAt,
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  CircleAvatar _buildAvatar(Conversation conversation) {
    final image = _setImgUrl(conversation);
    final user = _setConversationName(conversation);
    if (image != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(image),
      );
    }
    return CircleAvatar(
      child: Text(
        _initials(user),
        style: TextStyle(fontSize: 20),
      ),
      radius: 24.0,
    );
  }

  String _setImgUrl(Conversation conversation) {
    final receiver =
        conversation.participants.singleWhere((v) => v.sId != user.id);
    return receiver.image;
  }

  String _setConversationName(Conversation conversation) {
    final participant = conversation.participants.singleWhere(
      (v) => v.name != user.name,
    );

    return participant.name;
  }

  String _renderDate(String createdAt) {
    final time = DateTime.parse(createdAt);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(time.year, time.month, time.day);
    final formattedTime = DateFormat.jms().format(time);

    if (dateToCheck == today) {
      return formattedTime;
    } else if (dateToCheck == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }

  String _initials(name) {
    String firstname = name.split(" ")[0];
    String lastname = name.split(" ")[1];

    String initials =
        "${firstname[0].toUpperCase()}${lastname[0].toUpperCase()}";
    return initials;
  }
}
