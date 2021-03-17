import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProductFilters extends StatefulWidget {
  final String categoryId;

  ProductFilters(this.categoryId);
  @override
  _ProductFiltersState createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  double min = 0;
  double max = 10000;
  double startValue = 0;
  double endValue = 10000;

  TextEditingController startController = TextEditingController();

  TextEditingController endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        final maxPrice =
            await Provider.of<ProductController>(context, listen: false)
                .getMaxPrice();
        setState(() {
          max = maxPrice;
          endValue = maxPrice;
          startController.text = 0.toString();
          endController.text = maxPrice.toString();
        });
        final profileController =
            Provider.of<ProfileController>(context, listen: false);
        profileController.getCities();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController =
        Provider.of<ProfileController>(context);
    final productController = Provider.of<ProductController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              productController.getProductsForCategory(
                widget.categoryId,
                Provider.of<ProfileController>(
                  context,
                  listen: false,
                ).currentPosition,
              );
            },
            child: Text(
              "CLEAR ALL",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Price (₦)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                padding: EdgeInsets.zero,
                child: RangeSlider(
                  activeColor: kPrimaryColor,
                  min: min,
                  max: max,
                  values: RangeValues(
                    roundDouble(startValue),
                    roundDouble(endValue),
                  ),
                  onChanged: (values) {
                    setState(
                      () {
                        startValue = roundDouble(values.start);
                        endValue = roundDouble(values.end);

                        startController.text =
                            roundDouble(values.start).toString();
                        endController.text = roundDouble(values.end).toString();
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: startController,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        double doubleValue = double.parse(value);
                        if (doubleValue <= endValue) {
                          setState(() {
                            startValue = doubleValue;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'From',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: endController,
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        double doubleValue = double.parse(value);
                        if (doubleValue > startValue && doubleValue <= max) {
                          setState(() {
                            endValue = doubleValue;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'To',
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Region",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Please select a city';
                  }
                  return null;
                },
                onChanged: (value) {
                  profileController.setCity(value);
                },
                items: profileController.cities.map(
                  (city) {
                    return DropdownMenuItem(
                      value: city.name,
                      child: Text(city.name),
                    );
                  },
                ).toList(),
                decoration: InputDecoration(labelText: 'Cities'),
              ),
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Please select an area';
                  }
                  return null;
                },
                onChanged: (value) {
                  profileController.setAreaAndLatLng(value);
                },
                items: profileController.areas.map(
                  (area) {
                    return DropdownMenuItem(
                      value: area.name,
                      child: Text(area.name),
                    );
                  },
                ).toList(),
                decoration: InputDecoration(labelText: 'Areas'),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 250.0,
                  height: 45,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                    color: kPrimaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                      productController.filter(
                        startValue,
                        endValue,
                        profileController.selectedArea,
                        widget.categoryId,
                      );
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

double roundDouble(double value) {
  double mod = pow(10.0, 0);
  return ((value * mod).round().toDouble() / mod);
}
