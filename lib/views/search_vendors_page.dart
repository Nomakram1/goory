import 'package:flutter/material.dart';
import 'package:foodie/bloc/search_vendors.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/search.strings.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/appbar/empty_appbar.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/empty/empty_vendor_list.dart';
import 'package:foodie/widgets/vendors/grouped_vendors_listview.dart';
import 'package:foodie/widgets/search/search_bar.dart';

class SearchVendorsPage extends StatefulWidget {
  SearchVendorsPage({Key key}) : super(key: key);

  @override
  _SearchVendorsPageState createState() => _SearchVendorsPageState();
}

class _SearchVendorsPageState extends State<SearchVendorsPage> {
  //SearchVendorsBloc instance
  final SearchVendorsBloc _searchVendorsBloc = SearchVendorsBloc();

  //search bar focus node
  final _searchBarFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode.requestFocus();
    _searchVendorsBloc.initBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _searchVendorsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      appBar: EmptyAppBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            //vendors
            Positioned(
              //if you are using CustomAppbar
              //use this AppSizes.customAppBarHeight
              //or this AppSizes.secondCustomAppBarHeight, if you are using the second custom appbar
              top: AppSizes.secondCustomAppBarHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView(
                //padding: AppPaddings.defaultPadding(),
                padding: EdgeInsets.fromLTRB(
                  AppPaddings.contentPaddingSize,
                  MediaQuery.of(context).size.height * 0.10,
                  AppPaddings.contentPaddingSize,
                  AppPaddings.contentPaddingSize,
                ),
                children: <Widget>[
                  //Resut
                  StreamBuilder<List<Vendor>>(
                    stream: _searchVendorsBloc.searchVendors,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return EmptyVendor();
                      }

                      return GroupedVendorsListView(
                        title: SearchStrings.result,
                        titleTextStyle: AppTextStyle.h3TitleTextStyle(),
                        vendors: snapshot.data,
                      );
                    },
                  ),
                ],
              ),
            ),

            //filter and search header/bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              //normal
              child: Container(
                // height: AppSizes.secondCustomAppBarHeight,
                padding: AppPaddings.defaultPadding(),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //top view
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            SearchStrings.title,
                            style: AppTextStyle.h2TitleTextStyle(),
                          ),
                        ),

                        //close button
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),

                    UiSpacer.verticalSpace(),
                    SearchBar(
                      onSearchBarPressed: null,
                      onSubmit: _searchVendorsBloc.initSearch,
                      focusNode: _searchBarFocusNode,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
