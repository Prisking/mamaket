import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/products/widgets/product_widget.dart';
import 'package:mamaket/ui/pages/profile/controller/profile_controller.dart';
import 'package:mamaket/ui/pages/search/controller/search_controller.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatefulWidget {
  final String query;
  SearchResults(this.query);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<SearchController>(context, listen: false).search(
          widget.query,
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
      Provider.of<SearchController>(
        context,
        listen: false,
      ).getMore(
        widget.query,
        Provider.of<ProfileController>(
          context,
          listen: false,
        ).currentPosition,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<SearchController>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search"),
      ),
      body: _buildBody(productController),
    );
  }

  Widget _buildBody(SearchController searchController) {
    if (searchController.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!searchController.isLoading && searchController.results.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No product Found"),
          ],
        ),
      );
    }
    return Stack(
      children: <Widget>[
        ListView.builder(
          controller: _scrollController,
          itemCount: searchController.results.length,
          itemBuilder: (context, int index) {
            return ProductWidget(searchController.results[index]);
          },
        ),
        searchController.fetchingMore
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
