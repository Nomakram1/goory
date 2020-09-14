import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/data/models/sort_by.dart';

enum VendorFilterType { rating, deliveryTime, deliveryFee, minimumOrder }

class VendorFilterData {
  static List<SortBy> sortByList() {
    List<SortBy> sortBys = [];

    //rating sortby
    var mSortBy = SortBy(
      name: "Rating",
      vendorFilterType: VendorFilterType.rating,
      iconData: FlutterIcons.rate_review_mdi,
      iconActiveColor: AppColor.primaryColor,
    );
    sortBys.add(mSortBy);

    //delivery time sortby
    mSortBy = SortBy(
      name: "Delivery Time",
      vendorFilterType: VendorFilterType.deliveryTime,
      iconData: FlutterIcons.timelapse_mdi,
      iconActiveColor: AppColor.primaryColor,
    );
    sortBys.add(mSortBy);

    //delivery fee sortby
    mSortBy = SortBy(
      name: "Delivery Fee",
      vendorFilterType: VendorFilterType.deliveryFee,
      iconData: FlutterIcons.timelapse_mdi,
      iconActiveColor: AppColor.primaryColor,
    );
    sortBys.add(mSortBy);

    //minimum order sortby
    mSortBy = SortBy(
      name: "Minimum Order",
      vendorFilterType: VendorFilterType.minimumOrder,
      iconData: FlutterIcons.bag_sli,
      iconActiveColor: AppColor.primaryColor,
    );
    sortBys.add(mSortBy);

    return sortBys;
  }
}
