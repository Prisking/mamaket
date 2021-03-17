import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
// import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductWidget extends StatelessWidget {
  final PopulatedProduct product;
  ProductWidget(this.product);

  // static final userData = Hive.box("userData");
  // final User user = userData.get('user');

  @override
  Widget build(BuildContext context) {
    final productController =
        Provider.of<ProductController>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 150,
      child: GestureDetector(
        onTap: () {
          Get.toNamed("/product", arguments: product);
        },
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(5.0),
                topLeft: Radius.circular(4.0),
              ),
              child: Stack(
                children: <Widget>[
                  FadeInImage.memoryNetwork(
                    height: 150,
                    placeholder: kTransparentImage,
                    image: product.images[0],
                    fit: BoxFit.cover,
                  ),
                  DateTime.parse(product.sponsored).isAfter(DateTime.now())
                      ? Container(
                          child: Text(
                            "Sponsored",
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 18, color: kLightGrey),
                    ),
                    Text(
                      product.productSaleType,
                      style: TextStyle(color: kLightGrey),
                    ),
                    Text(
                      product.sellerId.region,
                      style: TextStyle(color: kLightGrey),
                    ),
                    Text(
                      productController.formatPrice(product.price),
                      style: TextStyle(fontSize: 18, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
            ),
            // ClipRRect(
            //   child: user.id == product.sellerId.sId
            //       ? Container()
            //       : Column(
            //           children: <Widget>[
            //             Container(
            //               color: kPrimaryColor,
            //               child: IconButton(
            //                 icon: Icon(
            //                   Icons.chat_bubble_outline,
            //                   color: Colors.white,
            //                 ),
            //                 onPressed: () {
            //                   Get.toNamed("/new-chat-screen",
            //                       arguments: product);
            //                 },
            //               ),
            //             ),
            //             Container(
            //               color: Colors.green,
            //               child: IconButton(
            //                 icon: Icon(
            //                   Icons.phone,
            //                   color: Colors.white,
            //                 ),
            //                 onPressed: () {
            //                   productController
            //                       .call(product.sellerId.phoneNumber);
            //                 },
            //               ),
            //             ),
            //             ValueListenableBuilder(
            //               valueListenable: userData.listenable(),
            //               builder: (context, box, _) {
            //                 final bookmarked = box.get("bookmarkedProducts");
            //                 if (bookmarked == null ||
            //                     !bookmarked.contains(product.sId)) {
            //                   return Container(
            //                     color: Colors.grey[700],
            //                     child: IconButton(
            //                       icon: Icon(
            //                         Icons.bookmark_border,
            //                         color: Colors.orangeAccent,
            //                       ),
            //                       onPressed: () {
            //                         productController.bookmarkProduct(
            //                           product.sId,
            //                         );
            //                       },
            //                     ),
            //                   );
            //                 } else {
            //                   return Container(
            //                     color: Colors.grey[700],
            //                     child: IconButton(
            //                       icon: Icon(
            //                         Icons.bookmark,
            //                         color: Colors.orangeAccent,
            //                       ),
            //                       onPressed: () {
            //                         productController.removeBookmark(
            //                           product.sId,
            //                         );
            //                       },
            //                     ),
            //                   );
            //                 }
            //               },
            //             ),
            //           ],
            //         ),
            // )
          ],
        ),
      ),
    );
  }
}
