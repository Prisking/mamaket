import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookmarkedProductItem extends StatelessWidget {
  final PopulatedProduct bookmarkedProduct;

  const BookmarkedProductItem({Key key, this.bookmarkedProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Get.toNamed("/product", arguments: bookmarkedProduct);
          },
          child: Image.network(
            bookmarkedProduct.images[0],
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(bookmarkedProduct.name),
              ),
              Container(
                child: Text(bookmarkedProduct.sellerId.region),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
