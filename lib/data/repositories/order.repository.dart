import 'package:foodie/constants/api.dart';
import 'package:foodie/data/models/api_response.dart';
import 'package:foodie/data/models/order.dart';
import 'package:foodie/services/http.service.dart';
import 'package:foodie/utils/api_response.utils.dart';

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
