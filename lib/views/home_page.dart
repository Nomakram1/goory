import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/views/cart_page.dart';
import 'package:Doory/views/home/grid_categories_page.dart';
import 'package:Doory/views/orders_page.dart';
import 'package:Doory/views/profile/profile_page.dart';
// import 'package:Doory/views/vendors_page.dart';
import 'package:Doory/widgets/appbar/empty_appbar.dart';
import 'package:Doory/widgets/custom_bottom_navigation_appbar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //current bottom navigation bar index
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      appBar: EmptyAppBar(),
      bottomNavigationBar: CustomBottomNavigationAppBar(
        selectedIndex: currentPageIndex,
        onTabSelected: _updateCurrentPageIndex,
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          //for normal vendors listing
          // VendorsPage(),
          //for switching between vendors and items listing
          // VendorsOrItemsPage(),
          //circular categories listing
          // CategoriesPage(),
          //grid card/elevated categories card listing
          GridCategoriesPage(),
          OrdersPage(),
          CartPage(),
          ProfilePage(),
        ],
        onPageChanged: _updateCurrentPageIndex,
      ),
    );
  }

  //update the current page index
  void _updateCurrentPageIndex(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
    });
    _pageController.animateToPage(
      pageIndex,
      curve: Curves.ease,
      duration: Duration(
        microseconds: 10,
      ),
    );
  }
}
