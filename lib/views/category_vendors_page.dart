import 'package:flutter/material.dart';
import 'package:foodie/bloc/search_vendors.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/category.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/widgets/appbar/empty_appbar.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/empty/empty_vendor_list.dart';
import 'package:foodie/widgets/vendors/grouped_vendors_listview.dart';

class CategoryVendorsPage extends StatefulWidget {
  CategoryVendorsPage({
    Key key,
    this.category,
  }) : super(key: key);

  final Category category;

  @override
  _CategoryVendorsPageState createState() => _CategoryVendorsPageState();
}

class _CategoryVendorsPageState extends State<CategoryVendorsPage> {
  //SearchVendorsBloc instance
  final SearchVendorsBloc _searchVendorsBloc = SearchVendorsBloc();

  @override
  void initState() {
    super.initState();
    _searchVendorsBloc.queryCategoryId = widget.category.id;
    _searchVendorsBloc.initBloc();
    _searchVendorsBloc.initSearch("", forceSearch: true);
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
              top: AppSizes.secondCustomAppBarHeight * 0.30,
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
                        title: "Result",
                        titleTextStyle: AppTextStyle.h3TitleTextStyle(),
                        vendors: snapshot.data,
                      );
                    },
                  ),
                ],
              ),
            ),

            //header/bar
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
                            widget.category.name,
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
