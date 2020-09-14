import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/data/models/sort_by.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/data/repositories/vendor.repository.dart';
import 'package:foodie/sample_data/vendor_filter_data.dart';
import 'package:rxdart/subjects.dart';
import 'package:dartx/dartx.dart';

class VendorsBloc extends BaseBloc {
  //VendorRepository instance
  VendorRepository _vendorRepository = VendorRepository();

  //Selected sort by item
  int selectedSortByIndex = 0;
  SortBy selectedSortBy;
  //minimum price
  double minimumFilterPrice = AppStrings.minFilterPrice;
  //maximum price
  double maximumFilterPrice = AppStrings.maxFilterPrice;

  //BehaviorSubjects
  BehaviorSubject<bool> _showOnlyAllVendors =
      BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<List<Vendor>> _justAddedVendors =
      BehaviorSubject<List<Vendor>>();
  BehaviorSubject<List<Vendor>> _popularVendors =
      BehaviorSubject<List<Vendor>>();
  BehaviorSubject<List<Vendor>> _allVendors = BehaviorSubject<List<Vendor>>();
  BehaviorSubject<List<Vendor>> _filteredVendors =
      BehaviorSubject<List<Vendor>>();

  //BehaviorSubject stream getters
  Stream<bool> get showOnlyAllVendors => _showOnlyAllVendors.stream;
  Stream<List<Vendor>> get justAddedVendors => _justAddedVendors.stream;
  Stream<List<Vendor>> get popularVendors => _popularVendors.stream;
  Stream<List<Vendor>> get allVendors => _allVendors.stream;
  Stream<List<Vendor>> get filteredVendors => _filteredVendors.stream;

  @override
  void initBloc() async {
    super.initBloc();

    //get the vendors
    getJustAddedVendors();
    getPopularVendors();
    getAllVendors();
  }

  //get all just added vendors
  void getJustAddedVendors() async {
    //add null data so listener can show shimmer widget to indicate loading
    _justAddedVendors.add(null);

    try {
      final vendors = await _vendorRepository.getVendors(
        type: VendorListType.newest,
      );
      _justAddedVendors.add(vendors);
    } catch (error) {
      print("Error getting Newest Vendors ==> $error");
    }
  }

  //get popular vendors
  void getPopularVendors() async {
    //add null data so listener can show shimmer widget to indicate loading
    _popularVendors.add(null);
    try {
      final vendors = await _vendorRepository.getVendors(
        type: VendorListType.popular,
      );
      _popularVendors.add(vendors);
    } catch (error) {
      print("Error getting Newest Vendors ==> $error");
    }
  }

  //get all vendors
  void getAllVendors() async {
    //add null data so listener can show shimmer widget to indicate loading
    _allVendors.add(null);

    try {
      final vendors = await _vendorRepository.getVendors(
        type: VendorListType.all,
      );
      _allVendors.add(vendors);
    } catch (error) {
      print("Error getting Newest Vendors ==> $error");
    }
  }

  void filterVendors() {
    _showOnlyAllVendors.add(true);
    _filteredVendors.add(null);
    //get all vendors
    final allVenders = _allVendors.value;
    //sort the all vendors by user selcted sorting method
    var sortedVendors = allVenders.sortedBy(
      (vendor) {
        if (selectedSortBy == null) {
          return vendor.name;
        } else if (selectedSortBy.vendorFilterType == VendorFilterType.rating) {
          return vendor.rating;
        } else if (selectedSortBy.vendorFilterType ==
            VendorFilterType.minimumOrder) {
          return vendor.minimumOrder;
        } else if (selectedSortBy.vendorFilterType ==
            VendorFilterType.deliveryFee) {
          return vendor.deliveryFee;
        } else if (selectedSortBy.vendorFilterType ==
            VendorFilterType.deliveryTime) {
          return vendor.minimumDeliveryTime;
        } else {
          return vendor.name;
        }
      },
    );

    //add price sorting if required
    //first sortby delivery fee of the range picked by the user
    if (selectedSortBy != null &&
        selectedSortBy.vendorFilterType == VendorFilterType.deliveryFee) {
      //remove vendors that are not in the range of selected price by the user
      sortedVendors.removeWhere(
        (vendor) =>
            vendor.deliveryFee < minimumFilterPrice ||
            vendor.deliveryFee > maximumFilterPrice,
      );
    } else if (selectedSortBy != null &&
        selectedSortBy.vendorFilterType == VendorFilterType.minimumOrder) {
      //remove vendors that are not in the range of selected price by the user
      sortedVendors.removeWhere(
        (vendor) =>
            vendor.minimumOrder < minimumFilterPrice ||
            vendor.minimumOrder > maximumFilterPrice,
      );
    }

    //add to the stream of filtered vendors
    _filteredVendors.add(sortedVendors);
  }

  void resetVendorFilter() {
    selectedSortBy = null;
    selectedSortByIndex = null;
    minimumFilterPrice = AppStrings.minFilterPrice;
    maximumFilterPrice = AppStrings.maxFilterPrice;
    _showOnlyAllVendors.add(false);
  }
}
