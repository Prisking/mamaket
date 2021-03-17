import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamaket/ui/pages/auth/models/user_model.dart';
import 'package:provider/provider.dart';

import 'controller/product_controller.dart';
import 'widgets/product_widget.dart';

class SponsoredProducts extends StatefulWidget {
  static Box userData = Hive.box("userData");

  static final User user = userData.get("user");
  final String sellerId;
  SponsoredProducts(this.sellerId);

  @override
  _SponsoredProductsState createState() => _SponsoredProductsState();
}

class _SponsoredProductsState extends State<SponsoredProducts> {
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
            .getSponsoredProductsForSeller(
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
      ).getMoreSponsoredProductsForSeller(
        widget.sellerId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Promoted Products"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => productController.getSponsoredProductsForSeller(
              widget.sellerId,
            ),
          )
        ],
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
        productController.sponsoredForSeller.length == 0) {
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
          itemCount: productController.sponsoredForSeller.length,
          itemBuilder: (context, int index) {
            return ProductWidget(
              productController.sponsoredForSeller[index],
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
