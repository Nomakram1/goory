import 'package:foodie/constants/api.dart';
import 'package:foodie/constants/strings/checkout.strings.dart';
import 'package:foodie/data/models/api_response.dart';
import 'package:foodie/data/models/dialog_data.dart';
import 'package:foodie/data/models/deliver_address.dart';
import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/payment_option.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/services/http.service.dart';
import 'package:foodie/utils/api_response.utils.dart';

class CheckOutRepository extends HttpService {
  //get available payment methods/options
  Future<List<PaymentOption>> paymentOptions() async {
    List<PaymentOption> paymentOptions = [];

    //make http call for vendors data
    final apiResult = await get(
      Api.paymentOptions,
    );

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    //convert the data to list of delivery address model
    paymentOptions = apiResponse.data
        .map((deliveryJSONObject) => PaymentOption.fromJSON(
              jsonObject: deliveryJSONObject,
            ))
        .toList();
    return paymentOptions;
  }

  Future<DialogData> initiateCheckout({
    PaymentOption paymentOption,
    DeliveryAddress deliveryAddress,
    Vendor vendor,
    Currency currency,
    double totalAmount,
    double subTotalAmount,
    double deliveryFee,
    List<Map<String, dynamic>> products,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    //make http call for vendors data
    final apiResult = await post(
      Api.initiateCheckout,
      {
        "payment_option_id": paymentOption.id.toString(),
        "delivery_address_id": deliveryAddress.id.toString(),
        "vendor_id": vendor.id.toString(),
        "currency_id": currency.id.toString(),
        "total_amount": totalAmount.toString(),
        "sub_total_amount": subTotalAmount.toString(),
        "delivery_fee": deliveryFee.toString(),
        "products": products,
      },
    );

    // print("Api result ==> $apiResult");

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (apiResponse.allGood) {
      resultDialogData.title = CheckoutStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;
      // resultDialogData.extraData = apiResponse.body["code"];
      resultDialogData.extraData = apiResponse.body;
    } else {
      resultDialogData.title = CheckoutStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }
}
