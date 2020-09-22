import 'package:Doory/constants/api.dart';
import 'package:Doory/data/models/api_response.dart';
import 'package:Doory/data/models/currency.dart';
import 'package:Doory/data/models/vendor.dart';
import 'package:Doory/services/http.service.dart';
import 'package:Doory/utils/api_response.utils.dart';

enum VendorListType {
  all,
  newest,
  popular,
}

class VendorRepository extends HttpService {
  //get vendors from server base on the type
  Future<List<Vendor>> getVendors({
    VendorListType type = VendorListType.all,
    String keyword = "",
    int categoryId,
  }) async {
    List<Vendor> vendors = [];

    //make http call for vendors data
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        "type": type.toString(),
        "keyword": keyword,
        "category_id": categoryId,
      },
    );

    // print("Api result ==> $apiResult");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    //currency
    final defultCurrency = Currency.fromJson(
      currencyJSONObject: apiResponse.body["currency"],
    );

    //save the newly gotten currency to database
    await appDatabase.currencyDao.deleteAll();
    await appDatabase.currencyDao.insertItem(defultCurrency);

    //convert the data to list of vendor model
    (apiResponse.body["vendors"] as List).forEach((vendorJSONObject) {
      //vendor data
      final mVendor = Vendor.fromJSON(
        jsonObject: vendorJSONObject,
      );

      mVendor.currency = defultCurrency;
      vendors.add(mVendor);
    });

    return vendors;
  }
}
