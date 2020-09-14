import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/strings/search.strings.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/data/repositories/vendor.repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchVendorsBloc extends BaseBloc {
  //
  int queryCategoryId;
  //VendorRepository instance
  VendorRepository _vendorRepository = VendorRepository();

  //BehaviorSubjects
  BehaviorSubject<List<Vendor>> _searchVendors =
      BehaviorSubject<List<Vendor>>();

  //BehaviorSubject stream getters
  Stream<List<Vendor>> get searchVendors => _searchVendors.stream;

  @override
  void initBloc() {
    super.initBloc();
    _searchVendors.addError("");
  }

  void initSearch(String value, {bool forceSearch = false}) async {
    //making sure user entered something before doing an api call
    if (value.isNotEmpty || forceSearch) {
      //add null data so listener can show shimmer widget to indicate loading
      _searchVendors.add(null);

      try {
        final vendors = await _vendorRepository.getVendors(
          type: VendorListType.all,
          keyword: value,
          categoryId: queryCategoryId,
        );

        if (vendors.length > 0) {
          _searchVendors.add(vendors);
        } else {
          _searchVendors.addError(SearchStrings.emptyTitle);
        }
      } catch (error) {
        _searchVendors.addError(error);
      }
    }
  }
}
