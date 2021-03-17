import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/bookmarks/bookmarks.dart';
import 'package:mamaket/ui/pages/home/controller/home_controller.dart';
import 'package:mamaket/ui/pages/messaging/controller/messaging_controller.dart';
import 'package:mamaket/ui/pages/messaging/conversations.dart';
import 'package:mamaket/ui/pages/products/main_page.dart';
import 'package:mamaket/ui/pages/products/upload.dart';
import 'package:mamaket/ui/pages/profile/account_details.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static final userData = Hive.box("userData");

  final _pagesBuyer = <Widget>[
    MainPage(),
    Bookmarks(),
    Conversations(),
    AccountDetails(),
  ];

  final _pagesSeller = <Widget>[
    MainPage(),
    Bookmarks(),
    Upload(),
    Conversations(),
    AccountDetails(),
  ];

  @override
  void initState() {
    super.initState();
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    profileController.initializeLocation();
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (message) async {
        Provider.of<MessagingController>(context, listen: false)
            .getConversations();
        Provider.of<MessagingController>(context, listen: false)
            .getUnreadCount();
        Provider.of<HomeController>(context, listen: false)
            .showSnackbar(message);
      },
      onLaunch: (message) async {
        Provider.of<HomeController>(context, listen: false).navigate(message);
      },
      onResume: (message) async {
        Provider.of<HomeController>(context, listen: false).navigate(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeController>(context);
    return ValueListenableBuilder(
      valueListenable: userData.listenable(),
      builder: (context, box, _) => Scaffold(
        body: box.get("user").role == "seller"
            ? _pagesSeller[home.currentIndex]
            : _pagesBuyer[home.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: box.get("user").role == "seller"
              ? tabItemsForSeller()
              : tabItemsForBuyer(),
          type: BottomNavigationBarType.fixed,
          currentIndex: home.currentIndex,
          onTap: home.changeIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: kPrimaryColor,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> tabItemsForBuyer() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bookmark_border),
        label: 'Bookmarks',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Inbox',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Account',
      ),
    ];
  }

  List<BottomNavigationBarItem> tabItemsForSeller() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bookmark_border),
        label: 'Bookmarks',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label: 'Upload',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Inbox',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Account',
      ),
    ];
  }
}
