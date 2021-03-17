import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/home/controller/home_controller.dart';
import 'package:mamaket/ui/pages/messaging/controller/messaging_controller.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:mamaket/ui/pages/products/widgets/product_widget.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

import 'widgets/category_widget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static Box userData = Hive.box("userData");
  final User user = userData.get("user");

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        final productProvider =
            Provider.of<ProductController>(context, listen: false);
        if (productProvider.isInit) {
          productProvider.getCategories();
          productProvider.getTrendingProducts(
            Provider.of<ProfileController>(
              context,
              listen: false,
            ).currentPosition,
          );
        } else {
          return;
        }
        final messagingController =
            Provider.of<MessagingController>(context, listen: false);
        messagingController.getUnreadCount();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductController>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileController>(context, listen: false);
    final homeProvider = Provider.of<HomeController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextField(
          cursorColor: Colors.grey[300],
          style: TextStyle(color: Colors.white),
          onSubmitted: (value) {
            if (value == "") {
              return;
            }
            Get.toNamed('/search-results', arguments: value);
          },
          controller: search,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey[300]),
            hintText: "What do you want to buy?",
            contentPadding: EdgeInsets.all(10.0),
            filled: true,
            fillColor: kPrimaryColor,
            hintStyle: TextStyle(color: Colors.grey[300]),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            suffix: GestureDetector(
              onTap: () {
                if (search.text == "") {
                  return;
                }
                Get.toNamed('/search-results', arguments: search.text);
              },
              child: Text(
                "Search",
                style: TextStyle(color: Colors.grey[300]),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              productProvider.getCategories();
              productProvider
                  .getTrendingProducts(profileProvider.currentPosition);
            },
          ),
          Consumer<MessagingController>(
            builder: (context, messagingProvider, child) => Stack(
              alignment: Alignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    if (user.role == "seller") {
                      homeProvider.setCurrentIndex(3);
                    } else {
                      homeProvider.setCurrentIndex(2);
                    }
                  },
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: messagingProvider.unreadCount == 0
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          width: 20,
                          height: 20,
                          child: Align(
                            alignment: Alignment.center,
                            child:
                                Text(messagingProvider.unreadCount.toString()),
                          ),
                        ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Consumer<ProductController>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!productProvider.isLoading &&
              productProvider.categories.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("No Data"),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: <Widget>[
              // SliverToBoxAdapter(
              //   child: Container(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 10.0,
              //         vertical: 25.0,
              //       ),
              //       child: Text(
              //         "Categories",
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return CategoryWidget(
                      category: productProvider.categories[index],
                    );
                  },
                  childCount: productProvider.categories.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 25.0,
                    ),
                    child: Text(
                      "Trending Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ProductWidget(
                      productProvider.trendingProducts[index],
                    );
                  },
                  childCount: productProvider.trendingProducts.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

// GridView.builder(
//             padding: const EdgeInsets.all(0.0),
//             itemCount: productProvider.categories.length,
//             itemBuilder: (context, index) {
//               return CategoryWidget(
//                   category: productProvider.categories[index]);
//             },
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 4 / 4,
//               crossAxisSpacing: 2,
//               mainAxisSpacing: 2,
//             ),
//           );
