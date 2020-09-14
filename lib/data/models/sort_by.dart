import 'package:flutter/material.dart';
import 'package:foodie/sample_data/vendor_filter_data.dart';

class SortBy {
  String name;
  VendorFilterType vendorFilterType;
  IconData iconData;
  Color iconColor;
  Color iconActiveColor;

  SortBy({
    this.name,
    this.vendorFilterType = VendorFilterType.rating,
    this.iconData,
    this.iconColor,
    this.iconActiveColor,
  });
}
