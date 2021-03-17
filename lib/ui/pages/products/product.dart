import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/services/star_rating.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final PopulatedProduct product;
  ProductPage(this.product);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  static Box userData = Hive.box("userData");

  final User user = userData.get("user");
  final List<String> bookmarkedProducts = userData.get("bookmarkedProducts");
  final controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        final productProvider =
            Provider.of<ProductController>(context, listen: false);

        productProvider.addProductView(widget.product);
        productProvider.getRating(widget.product.sellerId.sId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final productController = Provider.of<ProductController>(context);
    bool isOwner = user.id == widget.product.sellerId.sId;
    bool isNotSponsored =
        DateTime.parse(widget.product.sponsored).isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        centerTitle: true,
        actions: <Widget>[
          isOwner
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Get.toNamed(
                      "/edit-product",
                      arguments: widget.product,
                    );
                  },
                )
              : Container()
        ],
      ),
      body: Consumer<ProductController>(
        builder: (context, productController, child) {
          if (productController.isLoadingProduct) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Container(
                        height: 300,
                        child: PageView.builder(
                          itemCount: widget.product.images.length,
                          controller: controller,
                          itemBuilder: (context, index) => Container(
                            height: 300,
                            child: Image.network(
                              widget.product.images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          color: Colors.black.withOpacity(0.3),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              Text(
                                "Images (${widget.product.images.length})",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 25.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.product.description,
                        style: TextStyle(color: kLightGrey),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.product.sellerId.region,
                        style: TextStyle(color: kLightGrey),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            productController.formatPrice(widget.product.price),
                            style: TextStyle(
                              fontSize: 20,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              isOwner
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      onPressed: () => productController
                                              .isDisabled
                                          ? null
                                          : productController.initiateDelete(
                                              widget.product.sId,
                                            ),
                                    )
                                  : Container(),
                              ValueListenableBuilder(
                                valueListenable: userData.listenable(),
                                builder: (context, box, _) {
                                  final bookmarked =
                                      box.get("bookmarkedProducts");
                                  if (bookmarked == null ||
                                      !bookmarked
                                          .contains(widget.product.sId)) {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.bookmark_border,
                                        color: kPrimaryColor,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        productController.bookmarkProduct(
                                          widget.product.sId,
                                        );
                                      },
                                    );
                                  } else {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.bookmark,
                                        color: kPrimaryColor,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        productController.removeBookmark(
                                          widget.product.sId,
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${widget.product.views}",
                            style: TextStyle(color: kPrimaryColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      isOwner && isNotSponsored
                          ? RaisedButton(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(color: kPrimaryColor),
                              ),
                              child: Text(
                                "Promote Product",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                Get.toNamed(
                                  "/initialize-payment-existing",
                                  arguments: widget.product,
                                );
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: isOwner
                            ? <Widget>[
                                Container(),
                              ]
                            : <Widget>[
                                // ClipOval(
                                //   child: Container(
                                //     color: Colors.green,
                                //     width: 50,
                                //     height: 50,
                                //     child: IconButton(
                                //       onPressed: () => productController.call(
                                //           widget.product.sellerId.phoneNumber),
                                //       icon: Icon(
                                //         Icons.phone,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: RaisedButton(
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: BorderSide(color: kPrimaryColor),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.chat_bubble,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Chat with seller",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        Get.toNamed("/new-chat-screen",
                                            arguments: widget.product);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.product.sellerName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SmoothStarRating(
                                            key: UniqueKey(),
                                            allowHalfRating: true,
                                            onRated: (v) {},
                                            starCount: 5,
                                            rating:
                                                productController.sellerRating,
                                            size: 30.0,
                                            isReadOnly: true,
                                            halfFilledIconData: Icons.blur_on,
                                            color: Colors.orangeAccent,
                                            borderColor: Colors.orangeAccent,
                                            spacing: 0.0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "(${productController.numRating})")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            "/seller-profile",
                                            arguments: [
                                              widget.product.sellerId.sId,
                                              productController.numRating
                                            ].toList(),
                                          );
                                        },
                                        child: Text(
                                          "View seller profile",
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
