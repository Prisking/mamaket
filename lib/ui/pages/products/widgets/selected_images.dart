import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:provider/provider.dart';

class SelectedImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (productController.selectedImages.length >= 6) {
                return;
              }
              if (productController.isUploading) {
                return;
              }
              productController.handlemageSource();
            },
            child: Container(
              color: Colors.grey[200],
              height: 100,
              width: 100,
              child: Center(
                child: productController.isUploading
                    ? CircularProgressIndicator()
                    : IconButton(icon: Icon(Icons.add), onPressed: null),
              ),
            ),
          ),
          SizedBox(width: 10),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: productController.selectedImages.map(
              (image) {
                return Container(
                  color: Colors.grey[200],
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: <Widget>[
                      Image.network(image, fit: BoxFit.cover),
                      Positioned(
                        right: 2.0,
                        top: 2.0,
                        child: GestureDetector(
                          onTap: () {
                            productController.removeImage(image);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
