import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/data/models/sort_by.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/data/repositories/vendors_items.repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/subjects.dart';

class VendorsOrItemsBloc extends BaseBloc {
  //VendorsItemsRepository instance
  VendorsItemsRepository _vendorsItemsRepository = VendorsItemsRepository();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //Selected sort by item
  int selectedSortByIndex = 0;
  int queryPage = 1;
  SortBy selectedSortBy;
  //minimum price
  double minimumFilterPrice = AppStrings.minFilterPrice;
  //maximum price
  double maximumFilterPrice = AppStrings.maxFilterPrice;

  //BehaviorSubjects
  BehaviorSubject<bool> _showVendors = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<List<Vendor>> _allVendors = BehaviorSubject<List<Vendor>>();
  BehaviorSubject<List<Product>> _allProducts =
      BehaviorSubject<List<Product>>();

  //BehaviorSubject stream getters
  Stream<bool> get showVendors => _showVendors.stream;
  Stream<List<Vendor>> get allVendors => _allVendors.stream;
  Stream<List<Product>> get allProducts => _allProducts.stream;

  @override
  void initBloc() async {
    super.initBloc();

    //
    fetchData();
  }

  //get all just added vendors
  void fetchData({bool initialLoading = true}) async {
    if (initialLoading) {
      queryPage = 1;
      // add null data so listener can show shimmer widget to indicate loading
      _showVendors.add(null);
      _allVendors.add(null);
      _allProducts.add(null);
      refreshController.resetNoData();
    } else {
      queryPage++;
    }

    try {
      final vendorsOrProducts = await _vendorsItemsRepository.getVendorsItems(
        page: queryPage,
      );

      //if there was any data loaded
      if (vendorsOrProducts.length > 0) {
        //get the first model in the list
        final firstItem = vendorsOrProducts[0];

        //get the type of model
        //if the type is of vendor
        if (firstItem is Vendor) {
          _showVendors.add(true);
          final mVendors = vendorsOrProducts
              .map((vendorModel) => vendorModel as Vendor)
              .toList();
          _allVendors.add(mVendors);
        }
        //else the type is of product
        else {
          _showVendors.add(false);
          final mProducts = vendorsOrProducts
              .map((productModel) => productModel as Product)
              .toList();
          _allProducts.add(mProducts);
        }
      }

      //no data was loaded
      else if (initialLoading) {
        _showVendors.add(true);
        //emptyd
        _allVendors.add([]);
        _allProducts.add([]);
      }
      //clear prevnet
      if (initialLoading) {
        refreshController.refreshToIdle();
      } else {
        refreshController.loadComplete();
      }

      //prevent loading more is not data was returned
      if (vendorsOrProducts.length == 0) {
        refreshController.loadNoData();
      }
    } catch (error) {
      print("Error getting Newest Vendors/shops/items ==> $error");
    }
  }
}
