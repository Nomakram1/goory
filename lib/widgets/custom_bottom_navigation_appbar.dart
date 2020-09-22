import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/strings/bottom_nav_bar.strings.dart';
import 'package:Doory/data/database/app_database_singleton.dart';
import 'package:Doory/data/models/product.dart';

class CustomBottomNavigationAppBar extends BottomNavigationBar {
  CustomBottomNavigationAppBar({
    Key key,
    int selectedIndex,
    Function onTabSelected,
  }) : super(
          key: key,
          currentIndex: selectedIndex,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: onTabSelected,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FlutterIcons.home_ant,
                size: 20,
              ),
              title: Text(BottomNavBarStrings.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                AntDesign.inbox,
                size: 20,
              ),
              title: Text(BottomNavBarStrings.orders),
            ),
            BottomNavigationBarItem(
              //listen to stream on list of food in cart
              icon: StreamBuilder<List<Product>>(
                stream: AppDatabaseSingleton.database.productDao
                    .findAllProductsAsStream(),
                builder: (context, snapshot) {
                  return Badge(
                    badgeContent: Text(
                      //if no item in cart, don't even bother showing the cart item count
                      snapshot.hasData ? "${snapshot.data.length}" : "0",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    badgeColor: AppColor.accentColor,
                    //if no item in cart, don't even bother showing the badge
                    showBadge: snapshot.hasData && snapshot.data.length > 0,
                    position: BadgePosition.topRight(top: -5, right: -5),
                    child: Icon(
                      AntDesign.shoppingcart,
                    ),
                  );
                },
              ),
              title: Text(BottomNavBarStrings.cart),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FlutterIcons.user_ant,
                size: 20,
              ),
              title: Text(BottomNavBarStrings.profile),
            ),
          ],
        );
}
