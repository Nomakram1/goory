import 'package:Doory/constants/api.dart';
import 'package:Doory/data/models/api_response.dart';
import 'package:Doory/data/models/order.dart';
import 'package:Doory/services/http.service.dart';
import 'package:Doory/utils/api_response.utils.dart';

class OrderRepository extends HttpService {
  //get my orders from server
  Future<List<Order>> myOrders({
    int page = 1,
  }) async {
    List<Order> orders = [];

    //make http call for vendors data
    final apiResult = await get(Api.orders, queryParameters: {
      "page": page.toString(),
    });

    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    //convert the data to list of delivery address model
    (apiResponse.body["data"] as List).forEach((orderJSONObject) {
      orders.add(Order.fromJSON(
        jsonObject: orderJSONObject,
      ));
    });
    return orders;
  }
}
