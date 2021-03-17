import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/messaging/controller/messaging_controller.dart';
import 'package:provider/provider.dart';

class DeliveryForm extends StatefulWidget {
  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController deliveryCompany = TextEditingController();
  TextEditingController deliveryContactName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController deliveryContactNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageController = Provider.of<MessagingController>(
      context,
      listen: false,
    );
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter Delivery Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: deliveryCompany,
                  decoration: InputDecoration(labelText: 'Delivery Company'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter delivery company';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: deliveryContactName,
                  decoration:
                      InputDecoration(labelText: 'Delivery Contact Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter delivery contact name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: deliveryContactNumber,
                  decoration: InputDecoration(
                      labelText: 'Delivery Contact Phone Number'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter delivery contact phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: price,
                  decoration: InputDecoration(
                    labelText: 'Delivery Fee',
                    prefix: Text("₦ "),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter delivery fee';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50.0),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 250.0,
                        height: 45.0,
                        child: Consumer<MessagingController>(
                          builder: (context, controller, child) => RaisedButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: kPrimaryColor),
                            ),
                            onPressed: () {
                              if (controller.isDisabled) {
                                return null;
                              }
                              if (_formKey.currentState.validate()) {
                                messageController.sendDeliveryInfo(
                                  deliveryCompany: deliveryCompany.text,
                                  deliveryContactName: deliveryContactName.text,
                                  price: price.text,
                                  deliveryContactNumber:
                                      deliveryContactNumber.text,
                                );
                              }
                            },
                            child: controller.isDisabled
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
