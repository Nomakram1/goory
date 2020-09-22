import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/data/models/vendor.dart';
import 'package:Doory/views/vendor_page.dart';
import 'package:Doory/widgets/buttons/delivery_time_button.dart';

class HorizonalVendorListViewItem extends StatefulWidget {
  HorizonalVendorListViewItem({
    Key key,
    @required this.vendor,
  }) : super(key: key);

  final Vendor vendor;
  @override
  _HorizonalVendorListViewItemState createState() =>
      _HorizonalVendorListViewItemState();
}

class _HorizonalVendorListViewItemState
    extends State<HorizonalVendorListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.vendor.slug,
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: AppSizes.vendorImageHeight * 0.45,
                padding: AppPaddings.defaultPadding(),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(8),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.h5TitleTextStyle(),
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
    );
  }
}
