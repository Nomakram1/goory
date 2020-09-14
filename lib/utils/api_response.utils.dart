import 'package:foodie/data/models/api_response.dart';

class ApiResponseUtils {
  static ApiResponse parseApiResponse(dynamic response) {
    //
    int code = response.statusCode;
    dynamic body = response.data ?? null; // Would mostly be a Map
    List errors = new List();
    String message = "";

    switch (code) {
      case 200:
        try {
          message = body["message"];
        } catch (error) {
          print("Message reading error ==> $error");
        }

        break;
      default:
        message = body["message"] ??
            "Whoops! Something went wrong, please contact support.";
        errors.add(message);
        break;
    }

    // print("Gotten here");
    // print("Code ==> $code");
    // print("message ==> $message");
    // print("body ==> $body");
    // print("errors ==> $errors");

    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }
}
