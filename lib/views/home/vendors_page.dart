import 'package:flutter/material.dart';
import 'package:foodie/bloc/vendors.bloc.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/strings/home/vendors.strings.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/widgets/appbar/home_appbar.dart';
import 'package:foodie/widgets/empty/empty_vendor_list.dart';
import 'package:foodie/widgets/vendors/grouped_vendors_listview.dart';

class VendorsPage extends StatefulWidget {
  VendorsPage({Key key}) : super(key: key);

  @override
  _VendorsPageState createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage>
    with AutomaticKeepAliveClientMixin<VendorsPage> {
  @override
  bool get wantKeepAlive => true;
  //vendors bloc instance
  VendorsBloc _vendorsBloc = new VendorsBloc();

  @override
  void initState() {
    super.initState();
    _vendorsBloc.initBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              stream: _vendorsBloc.showOnlyAllVendors,
              builder: (context, snapshot) {
                //check if user is doing a filter
                final showOnlyAllVendors =
                    snapshot.hasData ? snapshot.data : false;

                //only show the just added, popular and all vendors grouping
                if (!showOnlyAllVendors) {
                  return ListView(
                    padding: AppPaddings.defaultPadding(),
                    children: <Widget>[
                      //Just added
                      StreamBuilder<List<Vendor>>(
                        stream: _vendorsBloc.justAddedVendors,
                        builder: (context, snapshot) {
                          return GroupedVendorsListView(
                            title: VendorsStrings.justAdded,
                            vendors: snapshot.data,
                          );
                        },
                      ),
                      //Popular
                      StreamBuilder<List<Vendor>>(
                        stream: _vendorsBloc.popularVendors,
                        builder: (context, snapshot) {
                          return GroupedVendorsListView(
                            title: VendorsStrings.popular,
                            vendors: snapshot.data,
                          );
                        },
                      ),
                      //All vendor
                      StreamBuilder<List<Vendor>>(
                        stream: _vendorsBloc.allVendors,
                        builder: (context, snapshot) {
                          return GroupedVendorsListView(
                            title: VendorsStrings.all,
                            vendors: snapshot.data,
                          );
                        },
                      ),
                    ],
                  );
                }
                //show only result of user filter
                else {
                  //All vendor
                  return ListView(
                    padding: AppPaddings.defaultPadding(),
                    children: <Widget>[
                      StreamBuilder<List<Vendor>>(
                        stream: _vendorsBloc.filteredVendors,
                        builder: (context, snapshot) {
                          //if not vendor was found show not result widget
                          if (!snapshot.hasData || snapshot.data.length == 0) {
                            return EmptyVendor();
                          }

                          return GroupedVendorsListView(
                            title: VendorsStrings.vendors,
                            vendors: snapshot.data,
                          );
                        },
                      ),
                    ],
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
