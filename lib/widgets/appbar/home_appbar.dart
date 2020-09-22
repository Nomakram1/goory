import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/bloc/vendors.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_routes.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/data/models/deliver_address.dart';
import 'package:Doory/utils/custom_dialog.dart';
import 'package:Doory/widgets/deliver_to_bottom_sheet_content.dart';
import 'package:Doory/widgets/search/search_bar.dart';
import 'package:Doory/widgets/vendor_filter.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key key,
    this.backgroundColor,
    this.vendorsBloc,
  }) : super(key: key);

  final Color backgroundColor;
  final VendorsBloc vendorsBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.secondCustomAppBarHeight,
      padding: AppPaddings.defaultPadding(),
      color: this.backgroundColor ?? Colors.white,
      child: Row(
        children: <Widget>[
          //search bar
          Expanded(
            flex: 8,
            child: SearchBar(
              onSearchBarPressed: () => _openSearchPage(context),
              readOnly: true,
            ),
          ),

          SizedBox(
            width: 10,
          ),
          //Delivery location
          Expanded(
            child: FlatButton(
              onPressed: () => _changeDeliveryAddress(context),
              padding: EdgeInsets.all(0),
              child: Icon(
                FlutterIcons.location_arrow_faw,
                size: 16,
                color: AppColor.iconHintColor,
              ),
            ),
          ),
          //filter action
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => _openFilterResults(context),
              child: Icon(
                FlutterIcons.sound_mix_ent,
                size: 16,
                color: AppColor.iconHintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //ui actions
  void _openSearchPage(context) {
    //navigate to search vendors page
    Navigator.pushNamed(
      context,
      AppRoutes.searchVendorsPage,
    );
  }

  void _openFilterResults(context) {
    //show bottomsheet with vendor filter container
    CustomDialog.showCustomBottomSheet(
      context,
      contentPadding: EdgeInsets.all(20),
      content: VendorFilter(
        vendorsBloc: this.vendorsBloc,
      ),
    );
  }

  void _changeDeliveryAddress(context) {
    //show bottomsheet with delivery addresses container
    CustomDialog.showCustomBottomSheet(
      context,
      contentPadding: EdgeInsets.all(20),
      content: DeliverTo(
        onSubmit: (DeliveryAddress selectedDeliveryAddres) {
          print("Selected Delivery ==> ${selectedDeliveryAddres.address}");
        },
      ),
    );
  }
}
