import 'package:flutter/material.dart';
import 'package:mamaket/ui/pages/bookmarks/products.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks>
    with SingleTickerProviderStateMixin {
  final Key keyOne = PageStorageKey("keyOne");
  final Key keyTwo = PageStorageKey("keyTwo");

  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "My Bookmarks",
              ),
              floating: true,
              centerTitle: true,
              snap: true,
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              // bottom: TabBar(
              //   indicatorWeight: 1.0,
              //   indicatorColor: Colors.white,
              //   controller: _tabController,
              //   tabs: <Widget>[
              //     Tab(
              //       text: "PRODUCTS",
              //     ),
              //     Tab(
              //       text: "ACCOUNTS",
              //     ),
              //   ],
              // ),
            )
          ];
        },
        body: BookmarkedProducts(
          keyOne: keyOne,
        ),
      ),
    );
  }
}
