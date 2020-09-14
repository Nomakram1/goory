import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_routes.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/cart.strings.dart';
import 'package:foodie/data/database/app_database_singleton.dart';
import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/cart/cart_item.dart';
import 'package:foodie/widgets/cart/total_cart_price.dart';
import 'package:foodie/widgets/empty/empty_cart.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin<CartPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          CartStrings.title,
          style: AppTextStyle.h1TitleTextStyle(),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<Currency>>(
        stream: AppDatabaseSingleton.database.currencyDao
            .findAllCurrenciesAsStream(),
        builder: (context, snapshot) {
          //if not currency was saved, show error
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.data.length == 0) {
            return EmptyCart();
          }

          //get the current/default currency
          final mCurrency = snapshot.data[0];
          return StreamBuilder<List<Product>>(
            stream: AppDatabaseSingleton.database.productDao
                .findAllProductsAsStream(),
            builder: (context, snapshot) {
              //if there is no item in cart, show empty cart widget
              if (!snapshot.hasData ||
                  snapshot.hasError ||
                  snapshot.data.length == 0) {
                return EmptyCart();
              }

              return Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppSizes.containerTopBorderRadiusShape(),
                  color: AppColor.primaryColor.withOpacity(0.10),
                ),
                child: ListView(
                  padding: AppPaddings.defaultPadding(),
                  children: <Widget>[
                    //list of items/food in cart
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return CartItem(
                          product: snapshot.data[index],
                          currency: mCurrency,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),

                    //total cart item
                    UiSpacer.verticalSpace(),
                    Divider(
                      thickness: 2,
                    ),
                    TotalCartPrice(
                      currency: mCurrency,
                    ),

                    //checkout button
                    UiSpacer.verticalSpace(space: 40),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CustomButton(
                        color: AppColor.accentColor,
                        child: Text(
                          CartStrings.checkout,
                          style: AppTextStyle.h4TitleTextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          //open checkout page
                          Navigator.pushNamed(
                            context,
                            AppRoutes.checkOutRoute,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
