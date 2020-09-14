import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/cart.strings.dart';
import 'package:foodie/data/database/app_database_singleton.dart';
import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/food_extra.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/buttons/outline_custom_button.dart';
import 'package:foodie/widgets/cornered_container.dart';

class CartItem extends StatefulWidget {
  CartItem({
    Key key,
    @required this.product,
    @required this.currency,
  }) : super(key: key);

  final Product product;
  final Currency currency;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductExtra>>(
      stream: AppDatabaseSingleton.database.productExtraDao
          .findAllByProductIdAsStream(widget.product.id),
      builder: (context, snapshot) {
        //the selected food options
        var selectedFoodExtras = "";
        //if snapshot has data, make a sentance out of the selected food options
        if (snapshot.hasData) {
          snapshot.data.forEach(
            (foodExtra) {
              selectedFoodExtras += selectedFoodExtras.isEmpty
                  ? foodExtra.name
                  : ", ${foodExtra.name}";
            },
          );
        }

        //cart item view
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CorneredContainer(
                  child: CachedNetworkImage(
                    imageUrl: widget.product.photoUrl,
                    placeholder: (context, url) => Container(
                      height: AppSizes.productImageHeight,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: AppSizes.productImageHeight,
                    width: AppSizes.productImageWidth,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product.name,
                        style: AppTextStyle.h4TitleTextStyle(),
                      ),
                      selectedFoodExtras.isNotEmpty
                          ? Text(
                              selectedFoodExtras,
                              style: AppTextStyle.h5TitleTextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          : SizedBox.shrink(),
                      Text(
                        "${widget.currency.symbol} ${widget.product.priceWithExtras}",
                        style: AppTextStyle.h5TitleTextStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //remove from cart
                ButtonTheme(
                  minWidth: 30,
                  height: 30,
                  child: CustomButton(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    color: Colors.red[400],
                    child: Row(
                      children: <Widget>[
                        Icon(
                          AntDesign.delete,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          CartStrings.remove,
                          style: AppTextStyle.h5TitleTextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: _removeFromCart,
                  ),
                ),

                Spacer(),
                ButtonTheme(
                  minWidth: 40,
                  height: 20,
                  child: CustomOutlineButton(
                    padding: EdgeInsets.all(
                      5,
                    ),
                    child: Icon(
                      AntDesign.minus,
                      size: 14,
                    ),
                    onPressed: (widget.product.selectedQuantity != null &&
                            widget.product.selectedQuantity > 1)
                        ? _decreaseFoodQuantity
                        : null,
                  ),
                ),
                //food qty in cart
                Padding(
                  padding: AppPaddings.buttonPadding(),
                  child: Text(
                    "${widget.product.selectedQuantity}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.h3TitleTextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 40,
                  height: 20,
                  child: CustomOutlineButton(
                    padding: EdgeInsets.all(
                      5,
                    ),
                    child: Icon(
                      AntDesign.plus,
                      size: 14,
                    ),
                    onPressed: _increaseFoodQuantity,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //decrease food qty
  void _decreaseFoodQuantity() {
    widget.product.selectedQuantity -= 1;
    AppDatabaseSingleton.database.productDao.updateItem(widget.product);
  }

  //increase food qty
  void _increaseFoodQuantity() {
    widget.product.selectedQuantity += 1;
    AppDatabaseSingleton.database.productDao.updateItem(widget.product);
  }

  //remove food from cart
  void _removeFromCart() {
    AppDatabaseSingleton.database.productExtraDao
        .deleteAllByProductId(widget.product.id);
    AppDatabaseSingleton.database.productDao.deleteItem(widget.product);
  }
}
