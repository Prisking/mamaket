import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/products/models/category_model.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

import 'controller/product_controller.dart';
import 'widgets/product_widget.dart';

class Products extends StatefulWidget {
  final Category category;
  Products(this.category);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
            .getProductsForCategory(
          widget.category.sId,
          Provider.of<ProfileController>(
            context,
            listen: false,
          ).currentPosition,
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
      ).getMoreProductsForCategory(
        widget.category.sId,
        Provider.of<ProfileController>(
          context,
          listen: false,
        ).currentPosition,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.category.name),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.of(context).pushNamed("/product-filters",
                    arguments: widget.category.sId);
              })
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
    if (!productController.isLoadingProducts &&
        productController.productsForCategory.length == 0) {
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
          itemCount: productController.productsForCategory.length,
          itemBuilder: (context, int index) {
            return ProductWidget(productController.productsForCategory[index]);
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
