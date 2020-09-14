import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:foodie/bloc/vendors.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/sample_data/vendor_filter_data.dart';
import 'package:foodie/data/models/sort_by.dart';
import 'package:foodie/utils/custom_dialog.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/filters/sort_by_filter_list_view_item.dart';

class VendorFilter extends StatefulWidget {
  VendorFilter({
    Key key,
    @required this.vendorsBloc,
  }) : super(key: key);

  final VendorsBloc vendorsBloc;
  @override
  _VendorFilterState createState() => _VendorFilterState();
}

class _VendorFilterState extends State<VendorFilter> {
  //sort by items
  List<SortBy> sortByList = VendorFilterData.sortByList();

  @override
  Widget build(BuildContext context) {
    return Container(
      //make if fill 60% of the screen
      // height: MediaQuery.of(context).size.height * 0.40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //sort by section
          Text(
            "Sort by",
            style: AppTextStyle.h3TitleTextStyle(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                width: 20,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _onSortBySelected(index);
                  },
                  // disabledColor: Colors.transparent,
                  // color: Colors.transparent,
                  child: SortByListViewItem(
                    sortBy: sortByList[index],
                    selected: widget.vendorsBloc.selectedSortByIndex == index,
                  ),
                );
              },
              itemCount: sortByList.length,
            ),
          ),

          //Filter by price
          //spaing into the price slider and the price header
          UiSpacer.verticalSpace(
            space: _showShowPirceSlider() ? 20 : 0,
          ),
          _showShowPirceSlider()
              ? Text(
                  "Price",
                  style: AppTextStyle.h3TitleTextStyle(),
                )
              : UiSpacer.verticalSpace(space: 0),

          //spaing into the price slider and the price header
          UiSpacer.verticalSpace(
            space: _showShowPirceSlider() ? 30 : 0,
          ),

          //only show price slider if the selected sortby requires it
          _showShowPirceSlider()
              ? FlutterSlider(
                  values: [
                    widget.vendorsBloc.minimumFilterPrice,
                    widget.vendorsBloc.maximumFilterPrice
                  ],
                  rangeSlider: true,
                  max: AppStrings.maxFilterPrice,
                  min: AppStrings.minFilterPrice,
                  trackBar: FlutterSliderTrackBar(
                    inactiveTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.inputFillColor,
                      border: Border.all(
                        width: 3,
                        color: AppColor.inputFillColor,
                      ),
                    ),
                    activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColor.primaryColor,
                    ),
                  ),
                  tooltip: FlutterSliderTooltip(
                    alwaysShowTooltip: true,
                    positionOffset:
                        FlutterSliderTooltipPositionOffset(top: -25),
                    leftPrefix: Text(
                      AppStrings.appCurrencySymbol,
                      style: AppTextStyle.h5TitleTextStyle(),
                    ),
                    rightPrefix: Text(
                      AppStrings.appCurrencySymbol,
                      style: AppTextStyle.h5TitleTextStyle(),
                    ),
                    textStyle: AppTextStyle.h4TitleTextStyle(),
                  ),
                  handler: FlutterSliderHandler(
                    child: Text(
                      AppStrings.appCurrencySymbol,
                    ),
                  ),
                  rightHandler: FlutterSliderHandler(
                    child: Text(
                      AppStrings.appCurrencySymbol +
                          AppStrings.appCurrencySymbol,
                    ),
                  ),
                  onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                    widget.vendorsBloc.minimumFilterPrice = lowerValue;
                    widget.vendorsBloc.maximumFilterPrice = upperValue;
                  },
                )
              : UiSpacer.verticalSpace(space: 0),

          //filter action button
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //clear filter
              Expanded(
                flex: 5,
                child: CustomButton(
                  color: Colors.grey[200],
                  textColor: Colors.black,
                  onPressed: _clearFilter,
                  child: Text(
                    "Clear",
                    style: AppTextStyle.h5TitleTextStyle(),
                  ),
                ),
              ),

              Spacer(),

              //Apply filter
              Expanded(
                flex: 5,
                child: CustomButton(
                  color: AppColor.accentColor,
                  textColor: Colors.white,
                  onPressed: _applyFilter,
                  child: Text(
                    "Apply",
                    style: AppTextStyle.h5TitleTextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //methods

  bool _showShowPirceSlider() {
    return widget.vendorsBloc.selectedSortBy != null &&
        (widget.vendorsBloc.selectedSortBy.vendorFilterType ==
                VendorFilterType.deliveryFee ||
            widget.vendorsBloc.selectedSortBy.vendorFilterType ==
                VendorFilterType.minimumOrder);
  }

  void _onSortBySelected(int index) {
    setState(() {
      widget.vendorsBloc.selectedSortByIndex = index;
      widget.vendorsBloc.selectedSortBy = sortByList[index];
    });
  }

  void _clearFilter() {
    setState(() {
      widget.vendorsBloc.resetVendorFilter();
    });

    CustomDialog.dismissDialog(context);
  }

  void _applyFilter() {
    CustomDialog.dismissDialog(context);
    widget.vendorsBloc.filterVendors();
  }
}
