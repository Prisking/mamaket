import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:provider/provider.dart';

import 'controller/product_controller.dart';
import 'widgets/product_widget.dart';

class SellerProducts extends StatefulWidget {
  static Box userData = Hive.box("userData");

  static final User user = userData.get("user");
  final String sellerId;
  SellerProducts(this.sellerId);

  @override
  _SellerProductsState createState() => _SellerProductsState();
}

class _SellerProductsState extends State<SellerProducts> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<ProductController>(context, listen: false)
            .getProductsForSeller(
          widget.sellerId,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll == 0) {
      Provider.of<ProductController>(
        context,
        listen: false,
      ).getMoreProductsForSeller(
        widget.sellerId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          SellerProducts.user.id == widget.sellerId
              ? "My Products"
              : "Products for seller",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => productController.getProductsForSeller(
              widget.sellerId,
            ),
          )
        ], //check if same user
      ),
      body: _buildBody(productController),
    );
  }

  Widget _buildBody(ProductController productController) {
    if (productController.isLoadingProducts) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!productController.isLoading &&
        productController.productsForSeller.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No Data"),
          ],
        ),
      );
    }
    return Stack(
      children: <Widget>[
        ListView.builder(
          controller: _scrollController,
          itemCount: productController.productsForSeller.length,
          itemBuilder: (context, int index) {
            return ProductWidget(
              productController.productsForSeller[index],
            );
          },
        ),
        productController.fetchingMore
            ? Align(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                alignment: FractionalOffset.bottomCenter,
              )
            : SizedBox(height: 0, width: 0),
      ],
    );
  }
}
