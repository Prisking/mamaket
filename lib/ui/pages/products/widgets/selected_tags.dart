import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:provider/provider.dart';

class SelectedTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    return Wrap(
      spacing: 2.0,
      children: productController.tags.map(
        (tag) {
          return Chip(
            backgroundColor: kPrimaryColor,
            label: Text(
              "#$tag",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            deleteIcon: Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            onDeleted: () {
              productController.removeTag(tag);
            },
          );
        },
      ).toList(),
    );
  }
}
