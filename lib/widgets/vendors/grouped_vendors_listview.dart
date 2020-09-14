import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:foodie/widgets/vendors/vendor_item_view.dart';

class GroupedVendorsListView extends StatelessWidget {
  const GroupedVendorsListView({
    Key key,
    @required this.title,
    this.vendors,
    this.titleTextStyle,
  }) : super(key: key);

  final String title;
  final TextStyle titleTextStyle;
  final List<Vendor> vendors;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Text(
          title,
          style: this.titleTextStyle ?? AppTextStyle.h2TitleTextStyle(),
        ),
        UiSpacer.verticalSpace(space: 20),
        ..._buildVendorsWidgetList(),
        UiSpacer.verticalSpace(space: 30),
      ],
    );
  }

  List<Widget> _buildVendorsWidgetList() {
    List<Widget> vendorsWidget = [];

    //create vendor widget out of the vendors data available
    if (vendors != null) {
      vendors.asMap().forEach(
        (index, vendor) {
          //prepare the vendor widget
          final vendorWidget = AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: VendorListViewItem(
                  vendor: vendor,
                ),
              ),
            ),
          );

          //append the new vendor widget to the list
          vendorsWidget.add(vendorWidget);
        },
      );
    } else {
      //add a shimmer widget
      vendorsWidget.add(
        VendorShimmerListViewItem(),
      );
    }

    return vendorsWidget;
  }
}
