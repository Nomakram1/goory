import 'package:Doory/constants/api.dart';
import 'package:Doory/data/models/api_response.dart';
import 'package:Doory/data/models/category.dart';
import 'package:Doory/services/http.service.dart';
import 'package:Doory/utils/api_response.utils.dart';

class CategoryRepository extends HttpService {
  //get vendors from server base on the type
  Future<List<Category>> getCategories() async {
    List<Category> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.categories);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      final category = Category(
        id: categoryJSONObject["id"],
        name: categoryJSONObject["name"],
        photo: categoryJSONObject["image"],
      );
      categories.add(category);
    });

    return categories;
  }
}
