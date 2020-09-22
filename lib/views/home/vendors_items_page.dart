import 'package:flutter/material.dart';
import 'package:Doory/bloc/vendors.bloc.dart';
import 'package:Doory/bloc/vendors_items.bloc.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/data/models/product.dart';
import 'package:Doory/data/models/vendor.dart';
import 'package:Doory/widgets/appbar/home_appbar.dart';
import 'package:Doory/widgets/listview/list_view_pull_up_footer.dart';
import 'package:Doory/widgets/product_list_view_item.dart';
import 'package:Doory/widgets/shimmers/general_shimmer_list_view_item.dart';
import 'package:Doory/widgets/state/state_loading_data.dart';
import 'package:Doory/widgets/vendors/vendor_shop_type_list_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VendorsOrItemsPage extends StatefulWidget {
  VendorsOrItemsPage({Key key}) : super(key: key);

  @override
  _VendorsOrItemsPageState createState() => _VendorsOrItemsPageState();
}

class _VendorsOrItemsPageState extends State<VendorsOrItemsPage> {
  //vendors bloc instance
  VendorsOrItemsBloc _vendorsOrItemsBloc = new VendorsOrItemsBloc();
  VendorsBloc _vendorsBloc = new VendorsBloc();

  @override
  void initState() {
    super.initState();
    _vendorsOrItemsBloc.initBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: StreamBuilder<bool>(
              stream: _vendorsOrItemsBloc.showVendors,
              builder: (context, snapshot) {
                final showVendors = snapshot.hasData ? snapshot.data : true;
                //only show the just added, popular and all vendors grouping
                if (showVendors) {
                  //show vendors/shops list
                  return StreamBuilder<List<Vendor>>(
                    stream: _vendorsOrItemsBloc.allVendors,
                    builder: (context, snapshot) {
                      //
                      if (!snapshot.hasData && !snapshot.hasError) {
                        return Padding(
                          padding: AppPaddings.defaultPadding(),
                          child: GeneralShimmerListViewItem(),
                        );
                      } else if (snapshot.hasError) {
                        return LoadingStateDataView();
                      }

                      //
                      final vendors = snapshot.data;
                      return SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: MaterialClassicHeader(),
                        footer: ListViewPullUpFooter(),
                        controller: _vendorsOrItemsBloc.refreshController,
                        onRefresh: _vendorsOrItemsBloc.fetchData,
                        onLoading: () {
                          _vendorsOrItemsBloc.fetchData(initialLoading: false);
                        },
                        child: ListView.separated(
                          padding: AppPaddings.defaultPadding(),
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            //
                            final vendor = vendors[index];
                            return VendorShopTypeListViewItem(
                              vendor: vendor,
                            );
                          },
                          itemCount: snapshot.data.length,
                        ),
                      );
                    },
                  );
                }
                //show only result of user filter
                else {
                  //show shops products list
                  return StreamBuilder<List<Product>>(
                    stream: _vendorsOrItemsBloc.allProducts,
                    builder: (context, snapshot) {
                      //
                      if (!snapshot.hasData && !snapshot.hasError) {
                        return GeneralShimmerListViewItem();
                      } else if (snapshot.hasError) {
                        return LoadingStateDataView();
                      }

                      //
                      final products = snapshot.data;
                      return SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: MaterialClassicHeader(),
                        footer: ListViewPullUpFooter(),
                        controller: _vendorsOrItemsBloc.refreshController,
                        onRefresh: _vendorsOrItemsBloc.fetchData,
                        onLoading: () {
                          _vendorsOrItemsBloc.fetchData(initialLoading: false);
                        },
                        child: ListView.separated(
                          padding: AppPaddings.defaultPadding(),
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            //
                            final product = products[index];
                            return ProductListViewItem(
                              product: product,
                              vendor: product.vendor,
                            );
                          },
                          itemCount: snapshot.data.length,
                        ),
                      );
                    },
                  );
                }
              },
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
