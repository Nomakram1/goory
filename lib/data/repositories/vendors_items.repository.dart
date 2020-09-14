import 'package:foodie/constants/api.dart';
import 'package:foodie/data/models/api_response.dart';
import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/services/http.service.dart';
import 'package:foodie/utils/api_response.utils.dart';

class VendorsItemsRepository extends HttpService {
  //get vendors/products from server base on the type
  Future<List<dynamic>> getVendorsItems({int page = 1}) async {
    List<dynamic> returnedData = [];

    //make http call for vendors data
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        "kind": "dynamic",
        "page": page.toString(),
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

    if (apiResponse.body["products"] != null) {
      //convert the data to list of vendor model
      (apiResponse.body["products"]["data"] as List)
          .forEach((productJSONObject) {
        //Product data
        final mProduct = Product.fromJSON(
          jsonObject: productJSONObject,
        );

        //Vendor
        final vendor = Vendor.fromJSON(
          jsonObject: productJSONObject["vendor"],
          withExtras: false,
        );
        vendor.currency = defultCurrency;
        mProduct.vendor = vendor;
        mProduct.currency = defultCurrency;
        returnedData.add(mProduct);
      });
    } else {
      //convert the data to list of vendor model
      (apiResponse.body["vendors"]["data"] as List).forEach((vendorJSONObject) {
        //vendor data
        final mVendor = Vendor.fromJSON(
          jsonObject: vendorJSONObject,
        );

        mVendor.currency = defultCurrency;
        returnedData.add(mVendor);
      });
    }

    return returnedData;
  }
}
