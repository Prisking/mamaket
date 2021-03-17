import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamaket/constants/constants.dart';

import 'models/product_model.dart';

class UploadDone extends StatelessWidget {
  final Product product;

  const UploadDone(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.toNamed("/home"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: kPrimaryColor,
                size: 100.0,
              ),
              SizedBox(height: 20.0),
              Container(
                width: 300,
                child: Text(
                  "Your product has been created Successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: kLightGrey),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 45,
                width: 250,
                child: RaisedButton(
                  color: kPrimaryColor,
                  onPressed: () => Get.toNamed(
                    "/initialize-payment",
                    arguments: product,
                  ),
                  child: Text(
                    "Promote Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                child: Text(
                  "You can promote your product to be visible to many customers",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kLightGrey),
                ),
              )
              //Boost Ad
              //Done
            ],
          ),
        ),
      ),
    );
  }
}
