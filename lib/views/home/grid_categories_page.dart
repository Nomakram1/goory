import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/bloc/categories.bloc.dart';
import 'package:foodie/bloc/vendors.bloc.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_routes.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/home/categories.strings.dart';
import 'package:foodie/data/models/category.dart';
import 'package:foodie/widgets/appbar/home_appbar.dart';
import 'package:foodie/widgets/shimmers/general_shimmer_list_view_item.dart';

class GridCategoriesPage extends StatefulWidget {
  GridCategoriesPage({Key key}) : super(key: key);

  @override
  _GridCategoriesPageState createState() => _GridCategoriesPageState();
}

class _GridCategoriesPageState extends State<GridCategoriesPage>
    with AutomaticKeepAliveClientMixin<GridCategoriesPage> {
  @override
  bool get wantKeepAlive => true;

  //categories bloc instance
  CategoriesBloc _categoriesBloc = new CategoriesBloc();
  VendorsBloc _vendorsBloc = new VendorsBloc();

  @override
  void initState() {
    super.initState();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPaddings.contentPaddingSize,
                    vertical: AppPaddings.buttonPaddingSize,
                  ),
                  child: Text(
                    CategoriesStrings.title,
                    style: AppTextStyle.h3TitleTextStyle(),
                  ),
                ),
                //categories
                Expanded(
                  child: StreamBuilder<List<Category>>(
                    stream: _categoriesBloc.categories,
                    builder: (context, snapshot) {
                      //loading shimmer
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: AppPaddings.defaultPadding(),
                          child: GeneralShimmerListViewItem(),
                        );
                      }

                      //device orientation
                      final orientation = MediaQuery.of(context).orientation;

                      return GridView.builder(
                        padding: AppPaddings.defaultPadding(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          //category
                          final category = snapshot.data[index];
                          return FlatButton(
                            onPressed: () {
                              //show all vendors associatee with selected category
                              Navigator.pushNamed(
                                context,
                                AppRoutes.categoryVendorsRoute,
                                arguments: category,
                              );
                            },
                            padding: AppPaddings.defaultPadding(),
                            color: Colors.grey[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //image
                                CachedNetworkImage(
                                  imageUrl: category.photo ?? "",
                                  height: AppSizes.categoryImageHeight,
                                  width: AppSizes.categoryImageWidth,
                                ),
                                //name
                                Text(
                                  category.name,
                                  style: AppTextStyle.h4TitleTextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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
}
