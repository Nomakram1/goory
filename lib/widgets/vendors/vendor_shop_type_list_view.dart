import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/home/vendors_items.strings.dart';
import 'package:Doory/data/models/vendor.dart';
import 'package:Doory/utils/ui_spacer.dart';
import 'package:Doory/views/vendor_page.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';
import 'package:Doory/widgets/cornered_container.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorShopTypeListViewItem extends StatelessWidget {
  const VendorShopTypeListViewItem({
    Key key,
    @required this.vendor,
  }) : super(key: key);

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: this.vendor.slug,
      child: FlatButton(
        onPressed: () => _openVendorPage(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //vendor feature image
                CorneredContainer(
                  height: AppSizes.vendorShopTypeImageHeight,
                  width: AppSizes.vendorShopTypeImageWidth,
                  child: CachedNetworkImage(
                    imageUrl: this.vendor.featureImage,
                    placeholder: (context, url) => Container(
                      height: AppSizes.vendorImageHeight,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: AppSizes.vendorShopTypeImageHeight,
                    width: AppSizes.vendorShopTypeImageWidth,
                    fit: BoxFit.cover,
                  ),
                ),

                //vendor basic info
                UiSpacer.horizontalSpace(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //vendor name
                      Text(
                        this.vendor.name,
                        style: AppTextStyle.h4TitleTextStyle(),
                      ),

                      //vendor/shop address
                      UiSpacer.verticalSpace(space: 2),
                      Text(
                        this.vendor.address,
                        style: AppTextStyle.h5TitleTextStyle(
                          color: Colors.grey[700],
                        ),
                      ),

                      //vendor/shop rating
                      UiSpacer.verticalSpace(space: 2),
                      Row(
                        children: [
                          Text(
                            this.vendor.rating.toString(),
                            style: AppTextStyle.h5TitleTextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          //rating bar
                          UiSpacer.horizontalSpace(space: 5),
                          RatingBar.readOnly(
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star,
                            filledColor: Colors.yellow[800],
                            emptyColor: Colors.grey[350],
                            size: 15,
                            initialRating: this.vendor.rating,
                          ),

                          //number of rating
                          UiSpacer.horizontalSpace(space: 5),
                          Text(
                            this.vendor.total_rating_count.toString() +
                                " " +
                                VendorsItemsStrings.ratings,
                            style: AppTextStyle.h5TitleTextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //
            UiSpacer.verticalSpace(space: 10),
            Row(
              children: [
                //
                Flexible(
                  child: CustomButton(
                    padding: AppPaddings.smallButtonPadding(),
                    borderColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColor.primaryColor,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //
                        Icon(
                          Icons.call,
                          size: 18,
                          color: AppColor.primaryColor,
                        ),
                        //
                        UiSpacer.horizontalSpace(space: 10),
                        Text(
                          VendorsItemsStrings.callNow,
                          style: AppTextStyle.h5TitleTextStyle(
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      //call vendor
                      launch('tel:${this.vendor.phoneNumber}');
                    },
                  ),
                ),

                //
                UiSpacer.horizontalSpace(space: 10),
                Flexible(
                  child: CustomButton(
                    padding: AppPaddings.smallButtonPadding(),
                    color: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //
                        Text(
                          VendorsItemsStrings.bestDeal,
                          style: AppTextStyle.h5TitleTextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _openVendorPage(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //open vendor details page
  void _openVendorPage(BuildContext context) {
    //show vendor full info and menu
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorPage(
          vendor: this.vendor,
        ),
      ),
    );
  }
}
