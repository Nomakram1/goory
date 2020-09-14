import 'package:foodie/constants/api.dart';
import 'package:foodie/constants/strings/profile/delivery_address.strings.dart';
import 'package:foodie/constants/strings/profile/edit_delivery_address.strings.dart';
import 'package:foodie/constants/strings/profile/new_delivery_address.strings.dart';
import 'package:foodie/data/models/api_response.dart';
import 'package:foodie/data/models/deliver_address.dart';
import 'package:foodie/data/models/dialog_data.dart';
import 'package:foodie/services/http.service.dart';
import 'package:foodie/utils/api_response.utils.dart';

class DeliveryAddressRepository extends HttpService {
  //get vendors from server base on the type
  Future<List<DeliveryAddress>> myDeliveryAddresses() async {
    List<DeliveryAddress> deliveryAddresses = [];

    //make http call for vendors data
    final apiResult = await get(
      Api.deliveryAddress,
    );

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    //convert the data to list of delivery address model
    deliveryAddresses = apiResponse.data
        .map((deliveryJSONObject) => DeliveryAddress.fromJSON(
              jsonObject: deliveryJSONObject,
            ))
        .toList();
    return deliveryAddresses;
  }

  //save user new delivery address
  Future<DialogData> saveDeliveryAddress({
    String name,
    String address,
    double latitude,
    double longitude,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    //make http call for vendors data
    final apiResult = await post(
      Api.deliveryAddress,
      {
        "name": name,
        "address": address,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      },
    );

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (apiResponse.allGood) {
      resultDialogData.title = NewDeliveryaAddressStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.successThenClosePage;
    } else {
      resultDialogData.title = NewDeliveryaAddressStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  //delete selected delivery address
  Future<DialogData> deleteDeliveryAddress({
    DeliveryAddress deliveryAddress,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    //make http call for vendors data
    final apiResult = await delete(
      "${Api.deliveryAddress}/${deliveryAddress.id}",
    );

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (apiResponse.allGood) {
      resultDialogData.title = DeliveryaAddressStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = DeliveryaAddressStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  //update user delivery address
  Future<DialogData> updateDeliveryAddress({
    int deliveryAddressId,
    String name,
    String address,
    double latitude,
    double longitude,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    //make http call for vendors data
    final apiResult = await patch(
      "${Api.deliveryAddress}/${deliveryAddressId}",
      {
        "name": name,
        "address": address,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      },
    );

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (apiResponse.allGood) {
      resultDialogData.title = EditDeliveryaAddressStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.successThenClosePage;
    } else {
      resultDialogData.title = EditDeliveryaAddressStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }
}
