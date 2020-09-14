import 'package:flutter/material.dart';
import 'package:foodie/bloc/categories.bloc.dart';
import 'package:foodie/bloc/vendors.bloc.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_routes.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/data/models/category.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/appbar/home_appbar.dart';
import 'package:foodie/widgets/buttons/category_button.dart';
import 'package:foodie/widgets/vendors/horizontal_vendor_item_view.dart';
import 'package:foodie/widgets/shimmers/general_shimmer_list_view_item.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({
    Key key,
  }) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin<CategoriesPage> {
  @override
  bool get wantKeepAlive => true;

  //vendors bloc instance
  VendorsBloc _vendorsBloc = new VendorsBloc();
  CategoriesBloc _categoriesBloc = new CategoriesBloc();

  @override
  void initState() {
    super.initState();
    _vendorsBloc.initBloc();
    _categoriesBloc.initBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      //
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          //cusines
          Positioned(
            //if you are using CustomAppbar
            //use this AppSizes.customAppBarHeight
            //or this AppSizes.secondCustomAppBarHeight, if you are using the second custom appbar
            top: AppSizes.secondCustomAppBarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomScrollView(
              slivers: [
                //Categorys
                SliverPadding(
                  padding: AppPaddings.defaultPadding(),
                  sliver: SliverToBoxAdapter(
                    child: StreamBuilder<List<Category>>(
                      stream: _categoriesBloc.categories,
                      builder: (context, snapshot) {
                        //loading shimmer
                        if (!snapshot.hasData) {
                          return GeneralShimmerListViewItem();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _buildCategorysList(snapshot.data),
                        );
                      },
                    ),
                  ),
                ),

                //vendors
                SliverToBoxAdapter(
                  child: Container(
                    height: 200.0,
                    child: StreamBuilder<List<Vendor>>(
                      stream: _vendorsBloc.justAddedVendors,
                      builder: (context, snapshot) {
                        //loading shimmer
                        if (!snapshot.hasData) {
                          return Padding(
                            padding: AppPaddings.defaultPadding(),
                            child: GeneralShimmerListViewItem(),
                          );
                        }

                        return ListView.separated(
                          padding: AppPaddings.defaultPadding(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              UiSpacer.horizontalSpace(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: HorizonalVendorListViewItem(
                                vendor: snapshot.data[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
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
            child: HomeAppBar(
              vendorsBloc: this._vendorsBloc,
            ),
          ),
        ],
      ),
    );
  }

  //
  List<Widget> _buildCategorysList(List<Category> categories) {
    final List<Widget> widgetChildren = [];
    List<Widget> widgetRowChildren = [];
    bool twoRowItem = true;
    int loop = 1;

    for (var index = 0; index < categories.length; index++) {
      //
      double buttonSize = MediaQuery.of(context).size.width * 0.25;
      double imageSize = 40;

      if (!twoRowItem && loop == 2) {
        buttonSize = MediaQuery.of(context).size.width * 0.30;
        imageSize = 60;
      }

      //
      final category = categories[index];
      widgetRowChildren.add(
        CategoryButton(
          height: buttonSize,
          width: buttonSize,
          imageSize: imageSize,
          category: category,
          onPressed: () {
            //show all vendors associatee with selected category
            Navigator.pushNamed(
              context,
              AppRoutes.categoryVendorsRoute,
              arguments: category,
            );
          },
        ),
      );

      if (twoRowItem && loop == 2) {
        final widgetChildRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetRowChildren,
        );
        widgetChildren.add(widgetChildRow);

        twoRowItem = false;
        loop = 0;
        widgetRowChildren = [];
      } else if (!twoRowItem && loop == 3) {
        final widgetChildRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetRowChildren,
        );
        widgetChildren.add(widgetChildRow);

        twoRowItem = true;
        loop = 0;
        widgetRowChildren = [];
      }
      loop++;
    }

    if (widgetRowChildren.length > 0) {
      final widgetChildRow = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgetRowChildren,
      );
      widgetChildren.add(widgetChildRow);
    }

    return widgetChildren;
  }
}
