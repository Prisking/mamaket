import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/routes.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mamaket/ui/pages/auth/controller/auth_controller.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/auth/sign_in.dart';
import 'package:mamaket/ui/pages/home/controller/home_controller.dart';
import 'package:mamaket/ui/pages/home/home.dart';
import 'package:mamaket/ui/pages/messaging/controller/messaging_controller.dart';
import 'package:mamaket/ui/pages/payment/controller/payment_controller.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:mamaket/ui/pages/search/controller/search_controller.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<Geometry>(GeometryAdapter());
  await Hive.openBox('userData');
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String accessToken = Hive.box("userData").get("accessToken");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => ProfileController(),
        ),
        ChangeNotifierProvider<ProductController>(
          create: (_) => ProductController(),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(),
        ),
        ChangeNotifierProvider<PaymentController>(
          create: (_) => PaymentController(),
        ),
        ChangeNotifierProvider<SearchController>(
          create: (_) => SearchController(),
        ),
        ChangeNotifierProvider<MessagingController>(
          create: (_) => MessagingController(),
        ),
      ],
      child: GetMaterialApp(
        enableLog: false,
        debugShowCheckedModeBanner: false,
        title: 'Mamaket',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: accessToken == null ? SignIn() : Home(),
        onGenerateRoute: Routes.generateRoutes,
        // home: UploadDone(null),
        // home: PaymentInitialize(null),
      ),
    );
  }
}
