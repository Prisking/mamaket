import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/bookmarks/widgets/bookmarked_product_item.dart';
import 'package:mamaket/ui/pages/products/controller/product_controller.dart';
import 'package:provider/provider.dart';

class BookmarkedProducts extends StatefulWidget {
  final Key keyOne;
  BookmarkedProducts({this.keyOne});

  @override
  _BookmarkedProductsState createState() => _BookmarkedProductsState();
}

class _BookmarkedProductsState extends State<BookmarkedProducts> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    Future.delayed(
      Duration.zero,
      () {
        final productProvider =
            Provider.of<ProductController>(context, listen: false);
        if (productProvider.isInitBookmarked) {
          productProvider.getBookmarkedProducts();
        } else {
          return;
        }
      },
    );
    super.initState();
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
      // Provider.of<ProductController>(context, listen: false).getMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductController>(context);

    if (productProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!productProvider.isLoading &&
        productProvider.bookmarkedProducts.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No Data"),
          ],
        ),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RefreshIndicator(
          onRefresh: () => productProvider.getBookmarkedProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(0.0),
            itemCount: productProvider.bookmarkedProducts.length,
            itemBuilder: (context, index) {
              return BookmarkedProductItem(
                  bookmarkedProduct: productProvider.bookmarkedProducts[index]);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 3),
          ),
        ),
      ),
    );
  }
}
