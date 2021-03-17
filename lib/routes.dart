import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/auth/forgot_password.dart';
import 'package:mamaket/ui/pages/auth/register_verification.dart';
import 'package:mamaket/ui/pages/auth/reset_password.dart';
import 'package:mamaket/ui/pages/auth/reset_verification.dart';
import 'package:mamaket/ui/pages/auth/sign_in.dart';
import 'package:mamaket/ui/pages/auth/sign_up.dart';
import 'package:mamaket/ui/pages/error/error.dart';
import 'package:mamaket/ui/pages/home/home.dart';
import 'package:mamaket/ui/pages/messaging/chat_screen.dart';
import 'package:mamaket/ui/pages/messaging/models/conversation_model.dart';
import 'package:mamaket/ui/pages/messaging/models/notification.dart';
import 'package:mamaket/ui/pages/messaging/notification_chat.dart';
import 'package:mamaket/ui/pages/messaging/tips_screen.dart';
import 'package:mamaket/ui/pages/payment/payment_initialize.dart';
import 'package:mamaket/ui/pages/payment/payment_initialize_existing.dart';
import 'package:mamaket/ui/pages/products/edit_product.dart';
import 'package:mamaket/ui/pages/products/filters.dart';
import 'package:mamaket/ui/pages/products/models/category_model.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:mamaket/ui/pages/products/models/product_model.dart';
import 'package:mamaket/ui/pages/products/products.dart';
import 'package:mamaket/ui/pages/products/product.dart';
import 'package:mamaket/ui/pages/products/seller_products.dart';
import 'package:mamaket/ui/pages/products/sponsored_products.dart';
import 'package:mamaket/ui/pages/products/upload_done.dart';
import 'package:mamaket/ui/pages/profile/change_password.dart';
import 'package:mamaket/ui/pages/profile/seller_profile.dart';
import 'package:mamaket/ui/pages/profile/update_profile.dart';
import 'package:mamaket/ui/pages/profile/update_region.dart';
import 'package:mamaket/ui/pages/search/search_results.dart';
import 'package:mamaket/ui/pages/settings/about_page.dart';
import 'package:mamaket/ui/pages/settings/account_settings.dart';

import 'ui/pages/messaging/new_chat_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => Home());
      case '/sign-in':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => SignIn());
      case '/sign-up':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => SignUp());
      case '/register-verification':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => RegisterVerification());
      case '/change-password':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ChangePassword());
      case '/reset-verification':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ResetVerification());
      case '/forgot-password':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ForgotPassword());
      case '/reset-password':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ResetPassword());
      case '/update-profile':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => UpdateProfile());
      case '/account-settings':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => AccountSetings());
      case '/update-region':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => UpdateRegion());
      case '/products':
        final Category category = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => Products(category));
      case '/product':
        final PopulatedProduct product = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(product));
      case '/edit-product':
        final PopulatedProduct product = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => EditProduct(product));
      case '/upload-done':
        final Product product = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => UploadDone(product));
      case '/initialize-payment':
        final Product product = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => PaymentInitialize(product));
      case '/initialize-payment-existing':
        final PopulatedProduct product = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) =>
                PaymentInitializeExisting(product));
      case '/search-results':
        final String query = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => SearchResults(query));
      case '/seller-products':
        final String sellerId = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => SellerProducts(sellerId));
      case '/seller-profile':
        final List arguments = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) =>
                SellerProfile(arguments[0], arguments[1]));
      case '/sponsored-products':
        final String sellerId = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => SponsoredProducts(sellerId));
      case '/chat-screen':
        final Conversation conversation = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ChatScreen(conversation));
      case '/notification-chat':
        final NotificationMod notificationMod = settings.arguments;
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => NotificationChat(notificationMod),
        );
      case '/new-chat-screen':
        final PopulatedProduct product = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => NewChat(product));
      case '/product-filters':
        final String categoryId = settings.arguments;
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductFilters(categoryId));
      case '/tips-screen':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => TipsScren());
      case '/about-page':
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => AboutPage());
      default:
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ErrorPage());
    }
  }
}
