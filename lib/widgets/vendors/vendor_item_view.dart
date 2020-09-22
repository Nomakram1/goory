import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/data/models/vendor.dart';
import 'package:Doory/views/vendor_page.dart';
import 'package:Doory/widgets/buttons/delivery_time_button.dart';

class VendorListViewItem extends StatefulWidget {
  VendorListViewItem({
    Key key,
    @required this.vendor,
  }) : super(key: key);

  final Vendor vendor;
  @override
  _VendorListViewItemState createState() => _VendorListViewItemState();
}

class _VendorListViewItemState extends State<VendorListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.vendor.slug,
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            //show vendor full info and menu
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VendorPage(
                  vendor: widget.vendor,
                ),
              ),
            );
          },
          // elevation: 3,
          // shape: StadiumBorder(),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: <Widget>[
              //vendor feature image
              CachedNetworkImage(
                imageUrl: widget.vendor.featureImage,
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

              //vendor info
              Container(
                padding: AppPaddings.defaultPadding(),
                margin: EdgeInsets.only(
                  top: AppSizes.vendorImageHeight - 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //vendor name
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.vendor.name,
                              style: AppTextStyle.h4TitleTextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          //rating, deliver fee
                          RichText(
                            text: TextSpan(
                              style: AppTextStyle.h5TitleTextStyle(),
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.star,
                                    size: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${widget.vendor.rating} ",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //food types and minimum order amount
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          //menu types
                          Expanded(
                            child: Text(
                              widget.vendor.categories,
                              style: AppTextStyle.h5TitleTextStyle(
                                color: AppColor.iconHintColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          //minimum order amount
                          Text(
                            "${AppStrings.minimumOrderLabel}${widget.vendor.currency.symbol}${widget.vendor.minimumOrder}",
                            style: AppTextStyle.h5TitleTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //delivery info
              //delivery time
              Positioned(
                right: 20,
                top: AppSizes.vendorImageHeight - 40,
                child: DeliveryTimeButton(
                  deliveryTime: widget.vendor.deliveryTime,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
