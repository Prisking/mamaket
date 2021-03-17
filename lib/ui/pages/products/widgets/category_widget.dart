import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/products/models/category_model.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/products', arguments: category);
        },
        child: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(
                    //     Color.fromRGBO(255, 255, 255, 0.19),
                    //     BlendMode.dstATop),
                    image: NetworkImage(
                      category.image,
                    ),
                  ),
                )),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.8),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
