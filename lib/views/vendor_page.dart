import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/vendor.strings.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/widgets/appbar/persistent_header.dart';
import 'package:foodie/widgets/headers/vendor_page_header.dart';
import 'package:foodie/widgets/vendor_menu_tab_bar_view.dart';

class VendorPage extends StatefulWidget {
  VendorPage({
    Key key,
    this.vendor,
  }) : super(key: key);

  final Vendor vendor;

  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  //show the empty space between the appbar and the tab with its reach top
  bool _makeAppBarTransparent = true;
  ScrollController _vendorPageStrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    //update app background color base on the scroll level
    _vendorPageStrollController.addListener(updateAppBarBackgroundColor);
  }

  @override
  void dispose() {
    super.dispose();
    _vendorPageStrollController.dispose();
  }

  //listen to when user scroll to the level when the vendor feature image isn't visible
  //then add background to the appbar else make it transparent
  void updateAppBarBackgroundColor() {
    if (_vendorPageStrollController.offset >= AppSizes.vendorPageImageHeight) {
      if (_makeAppBarTransparent) {
        setState(() {
          _makeAppBarTransparent = !_makeAppBarTransparent;
        });
      }
    } else {
      if (!_makeAppBarTransparent) {
        setState(() {
          _makeAppBarTransparent = !_makeAppBarTransparent;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.vendor.menus.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          backgroundColor: _makeAppBarTransparent ? Colors.transparent : null,
          elevation: 0,
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: _makeAppBarTransparent
                  ? AppColor.primaryColorDark
                  : Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: EdgeInsets.all(0),
          child: NestedScrollView(
            controller: _vendorPageStrollController,
            headerSliverBuilder: (context, value) {
              return [
                //vendor information header
                VendorPageHeader(
                  vendor: widget.vendor,
                ),

                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: PersistentHeader(
                    height: 100,
                    widget: Text(
                      VendorStrings.menu,
                      style: AppTextStyle.h3TitleTextStyle(),
                    ),
                  ),
                ),

                // vendor menu types appbar with tabs
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: PersistentHeader(
                    widget: TabBar(
                      labelColor: AppColor.primaryColor,
                      unselectedLabelColor: Colors.black,
                      isScrollable: true,
                      indicatorWeight: 3.0,
                      indicatorPadding: EdgeInsets.all(0),
                      labelStyle: AppTextStyle.h4TitleTextStyle(),
                      unselectedLabelStyle: AppTextStyle.h5TitleTextStyle(),
                      tabs: widget.vendor.menus.map(
                        (menu) {
                          return Tab(
                            text: menu.name,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: widget.vendor.menus.map(
                (menu) {
                  return VendorMenuTabBarView(
                    menu: menu,
                    vendor: widget.vendor,
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
