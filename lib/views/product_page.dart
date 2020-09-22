import 'package:cached_network_image/cached_network_image.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:Doory/bloc/product.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/product.strings.dart';
import 'package:Doory/data/models/product.dart';
import 'package:Doory/data/models/vendor.dart';
import 'package:Doory/utils/custom_dialog.dart';
import 'package:Doory/utils/ui_spacer.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';
import 'package:Doory/widgets/buttons/outline_custom_button.dart';
import 'package:Doory/widgets/product_extra_list_view_item.dart';
import 'package:readmore/readmore.dart';

class ProductPage extends StatefulWidget {
  ProductPage({
    Key key,
    this.product,
    this.vendor,
  }) : super(key: key);

  final Product product;
  final Vendor vendor;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //food bloc
  ProductBloc _productBloc = ProductBloc();

  @override
  void initState() {
    super.initState();

    _productBloc.selectedProduct = widget.product;
    _productBloc.selectedVendor = widget.vendor;
    _productBloc.initBloc();

    //listen to the need to show a normal snackbar alert type
    _productBloc.showAlert.listen(
      (show) {
        //when asked to show an alert
        if (show) {
          EdgeAlert.show(
            context,
            title: _productBloc.dialogData.title,
            description: _productBloc.dialogData.body,
            backgroundColor: _productBloc.dialogData.backgroundColor,
            icon: _productBloc.dialogData.iconData,
          );
        }
      },
    );

    //listen to the need to show a dialog alert type
    _productBloc.showDialogAlert.listen(
      (show) {
        //when asked to show an alert
        if (show) {
          CustomDialog.showConfirmationActionAlertDialog(
            context,
            _productBloc.dialogData,
            negativeButtonAction: () {
              //dismiss dialog
              CustomDialog.dismissDialog(
                context,
              );
            },
            positiveButtonAction: () {
              //dismiss dialog
              CustomDialog.dismissDialog(
                context,
              );

              //call add to cart but this time clear all previous items in cart
              _productBloc.addToCart(override: true);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
        ),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          //food details and options
          Positioned(
            child: ListView(
              padding: EdgeInsets.only(
                bottom: 300,
              ),
              children: <Widget>[
                //food featured image
                Hero(
                  tag: widget.product.id,
                  child: CachedNetworkImage(
                    imageUrl: widget.product.photoUrl,
                    placeholder: (context, url) => Container(
                      height: AppSizes.vendorImageHeight,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: AppSizes.vendorImageHeight,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                //food name and price
                Container(
                  padding: AppPaddings.defaultPadding(),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(0, 1.0),
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: AppTextStyle.h2TitleTextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      UiSpacer.horizontalSpace(space: 20),
                      Text(
                        "${widget.vendor.currency.symbol} ${widget.product.price}",
                        style: AppTextStyle.h1TitleTextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                //food description
                Container(
                  padding: AppPaddings.defaultPadding(),
                  child: ReadMoreText(
                    widget.product.description,
                    trimLines: 4,
                    colorClickableText: AppColor.primaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...show more',
                    trimExpandedText: ' show less',
                    style: AppTextStyle.h5TitleTextStyle(),
                  ),
                ),

                Divider(),

                //food extras
                Padding(
                  padding: AppPaddings.defaultPadding(),
                  child: Text(
                    ProductStrings.extras,
                    style: AppTextStyle.h3TitleTextStyle(),
                  ),
                ),
                //list of the extras
                ..._buildFoodExtrasWidgetList(),
              ],
            ),
          ),
          //add to cart section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppPaddings.defaultPadding(),
              decoration: BoxDecoration(
                borderRadius: AppSizes.containerTopBorderRadiusShape(),
                color: Colors.white,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          ProductStrings.quantity,
                          style: AppTextStyle.h4TitleTextStyle(),
                        ),
                        Spacer(
                          flex: 6,
                        ),
                        //decrease food quantity button
                        ButtonTheme(
                          minWidth: 40,
                          height: 30,
                          child: StreamBuilder<int>(
                            stream: _productBloc.selectedFoodQuantity,
                            builder: (context, snapshot) {
                              return CustomOutlineButton(
                                padding: EdgeInsets.all(5),
                                color: AppColor.accentColor,
                                child: Icon(
                                  FlutterIcons.minus_ant,
                                  size: 16,
                                ),
                                onPressed: snapshot.data == 1
                                    ? null
                                    : _productBloc.decreaseFoodQuantity,
                              );
                            },
                          ),
                        ),
                        //selected food quantity text
                        Expanded(
                          flex: 2,
                          child: StreamBuilder<int>(
                              stream: _productBloc.selectedFoodQuantity,
                              builder: (context, snapshot) {
                                return Text(
                                  "${snapshot.data}",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.h3TitleTextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              }),
                        ),
                        //increase food quantity button
                        ButtonTheme(
                          minWidth: 40,
                          height: 30,
                          child: CustomOutlineButton(
                            padding: EdgeInsets.all(5),
                            color: AppColor.accentColor,
                            child: Icon(
                              FlutterIcons.plus_ant,
                              size: 16,
                            ),
                            onPressed: _productBloc.increaseFoodQuantity,
                          ),
                        ),
                      ],
                    ),

                    UiSpacer.verticalSpace(),

                    //add to cart buttonn
                    CustomButton(
                      color: AppColor.accentColor,
                      padding: AppPaddings.mediumButtonPadding(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            ProductStrings.addToCart,
                            style: AppTextStyle.h4TitleTextStyle(
                              color: Colors.white,
                            ),
                          ),
                          UiSpacer.horizontalSpace(),
                          StreamBuilder<String>(
                            stream: _productBloc.totalFoodAmount,
                            builder: (context, snapshot) {
                              final totalAmount = snapshot.data ?? "0.00";
                              return Text(
                                "${widget.vendor.currency.symbol} $totalAmount",
                                style: AppTextStyle.h3TitleTextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      onPressed: _productBloc.addToCart,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildFoodExtrasWidgetList() {
    List<Widget> productExtrasWidget = [];

    //create food widget out of the vendors data available
    if (widget.product.extras.length > 0) {
      widget.product.extras.asMap().forEach(
        (index, productExtra) {
          //prepare the vendor widget
          final foodExtraWidget = AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ProductExtraListViewItem(
                  productExtra: productExtra,
                  currency: widget.vendor.currency,
                  onPressed: _productBloc.updateSelectedFoodExtras,
                ),
              ),
            ),
          );

          productExtrasWidget.add(foodExtraWidget);
        },
      );
    } else {
      //return a text widget informating the user of no extra option
      productExtrasWidget.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPaddings.contentPaddingSize,
          ),
          child: Text(
            ProductStrings.emptyBody,
            style: AppTextStyle.h5TitleTextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return productExtrasWidget;
  }
}
