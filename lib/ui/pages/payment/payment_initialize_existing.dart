import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:mamaket/ui/pages/home/controller/home_controller.dart';
import 'package:mamaket/ui/pages/payment/controller/payment_controller.dart';
import 'package:mamaket/ui/pages/products/models/populated_product_model.dart';
import 'package:provider/provider.dart';

class PaymentInitializeExisting extends StatefulWidget {
  final PopulatedProduct product;
  PaymentInitializeExisting(this.product);

  @override
  _PaymentInitializeExistingState createState() =>
      _PaymentInitializeExistingState();
}

class _PaymentInitializeExistingState extends State<PaymentInitializeExisting> {
  var publicKey = kPaystackKey;

  static Box userData = Hive.box("userData");

  final User user = userData.get("user");

  @override
  void initState() {
    super.initState();
    PaystackPlugin.initialize(publicKey: publicKey);
  }

  checkOut(String accessCode, String reference, int amount) async {
    Charge charge = Charge()
      ..amount = amount * 100
      ..accessCode = accessCode
      ..reference = reference
      ..email = user.email;

    try {
      CheckoutResponse response =
          await PaystackPlugin.checkout(context, charge: charge);
      return response;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //provider here
    final paymentcontroller = Provider.of<PaymentController>(context);
    final home = Provider.of<HomeController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Promote Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: paymentcontroller.type,
                  onChanged: (int value) {
                    paymentcontroller.setTypeAndAmount(value, 1500);
                  },
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red,
                  ),
                  padding: EdgeInsets.all(5.0),
                  width: 130,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Standard",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Promo runs for 7 days"),
                    Text(
                      "@ N1,500",
                      style: TextStyle(color: kPrimaryColor),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Radio(
                  value: 2,
                  groupValue: paymentcontroller.type,
                  onChanged: (int value) {
                    paymentcontroller.setTypeAndAmount(value, 3000);
                  },
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFFE98F0D),
                  ),
                  width: 130,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Prime",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Promo runs for 15 days"),
                    Text(
                      "@ N3,000",
                      style: TextStyle(color: kPrimaryColor),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Radio(
                  value: 3,
                  groupValue: paymentcontroller.type,
                  onChanged: (int value) {
                    paymentcontroller.setTypeAndAmount(value, 5000);
                  },
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFF102D43),
                  ),
                  width: 130,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Ultimate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Promo runs for 30 days"),
                    Text(
                      "@ N5,000",
                      style: TextStyle(color: kPrimaryColor),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            RaisedButton(
              color: kPrimaryColor,
              child: paymentcontroller.busy
                  ? Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Text(
                      "Pay",
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () async {
                final result = await paymentcontroller.initializeTransaction(
                  widget.product.sId,
                );
                if (result == null) {
                  return;
                }
                final CheckoutResponse response = await checkOut(
                  result.accessCode,
                  result.reference,
                  paymentcontroller.amount,
                );
                print(response);
                paymentcontroller.showSnackbar(
                    response.status ? "Success" : "Terminated",
                    response.message);
                home.setCurrentIndex(0);
                Get.toNamed("/home");
              },
            )
          ],
        ),
      ),
    );
  }
}
