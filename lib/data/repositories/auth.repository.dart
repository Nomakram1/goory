import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:foodie/constants/api.dart';
import 'package:foodie/constants/strings/forgot_password.strings.dart';
import 'package:foodie/constants/strings/login.strings.dart';
import 'package:foodie/constants/strings/register.strings.dart';
import 'package:foodie/constants/strings/update_password.strings.dart';
import 'package:foodie/constants/strings/update_profile.strings.dart';
import 'package:foodie/data/models/api_response.dart';
import 'package:foodie/data/models/dialog_data.dart';
import 'package:foodie/data/models/user.dart';
import 'package:foodie/services/http.service.dart';
import 'package:foodie/utils/api_response.utils.dart';
import 'package:tellam/tellam.dart';

class AuthRepository extends HttpService {
  //FirebaseMessaging instance
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  //process user account login
  Future<DialogData> login({String email, String password}) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.login,
      {
        "email": email,
        "password": password,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = LoginStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;

      //save the user data to hive box
      saveuserData(
        apiResponse.body["user"],
        apiResponse.body["token"],
        apiResponse.body["type"],
      );
    } else {
      resultDialogData.title = LoginStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  Future<DialogData> register({
    String name,
    String email,
    String phone,
    String password,
    bool social = false,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.register,
      {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "social": social ? "1" : "0"
      },
    );

    // print("Api Result ==> $apiResult");
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = RegisterStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;

      //save the user data to hive box
      saveuserData(
        apiResponse.body["user"],
        apiResponse.body["token"],
        apiResponse.body["type"],
      );
    } else {
      resultDialogData.title = RegisterStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  Future<DialogData> loginSocial({
    String name,
    String email,
    String phone,
    String password,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.loginSocial,
      {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      },
    );

    // print("Api Result ==> $apiResult");
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = RegisterStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;

      //save the user data to hive box
      saveuserData(
        apiResponse.body["user"],
        apiResponse.body["token"],
        apiResponse.body["type"],
      );
    } else {
      resultDialogData.title = RegisterStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  //reset password
  Future<DialogData> resetPassword({
    @required String email,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.forgotPassword,
      {
        "email": email,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = ForgotPasswordStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = ForgotPasswordStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  //update account profile
  Future<DialogData> updateProfile({
    String name,
    String email,
    String phone,
    String photo,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();

    final apiResult = await post(
      Api.updateProfile,
      {
        "name": name,
        "email": email,
        "phone": phone,
        "photo": photo,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (apiResponse.allGood) {
      resultDialogData.title = UpdateProfileStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.successThenClosePage;

      //get the local version of user data
      final currentUser = await appDatabase.userDao.findCurrent();
      //change the data/info
      currentUser.name = name;
      currentUser.email = email;
      currentUser.phone = phone;
      //making sure we only update photo is user changed photo
      currentUser.photo = photo.isNotEmpty ? photo : currentUser.photo;
      //update the local version of user data
      await appDatabase.userDao.updateItem(currentUser);
    } else {
      //the error message
      var errorMessage = apiResponse.message;

      try {
        errorMessage += "\n" + apiResponse.body["errors"]["name"][0];
      } catch (error) {
        print("Name Validation ===> $error");
      }
      try {
        errorMessage += "\n" + apiResponse.body["errors"]["email"][0];
      } catch (error) {
        print("Email Validation ===> $error");
      }

      resultDialogData.title = UpdateProfileStrings.processFailedTitle;
      resultDialogData.body = errorMessage ?? apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }
    return resultDialogData;
  }

  //update user password
  Future<DialogData> updatePassword({
    String currentPassword,
    String newPassword,
    String confirmNewPassword,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.changePassword,
      {
        "current_password": currentPassword,
        "new_password": newPassword,
        "new_password_confirmation": confirmNewPassword,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = UpdatePasswordStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.successThenClosePage;
    } else {
      //the error message
      var errorMessage = apiResponse.message;

      try {
        errorMessage +=
            "\n" + apiResponse.body["errors"]["current_password"][0];
      } catch (error) {
        print("Current Password ===> $error");
      }
      try {
        errorMessage += "\n" + apiResponse.body["errors"]["new_password"][0];
      } catch (error) {
        print("New Password ===> $error");
      }

      try {
        errorMessage +=
            "\n" + apiResponse.body["errors"]["new_password_confirmation"][0];
      } catch (error) {
        print("New Password Confirmation ===> $error");
      }

      resultDialogData.title = UpdatePasswordStrings.processFailedTitle;
      resultDialogData.body = errorMessage ?? apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  //save user data
  void saveuserData(dynamic userObject, String token, String tokenType) async {
    //this is variable is inherited from HttpService
    final mUser = User.formJson(userJSONObject: userObject);
    mUser.token = token;
    mUser.tokenType = tokenType;
    await appDatabase.userDao.insertItem(mUser);

    //save to tellam
    TellamUser tellamUser = TellamUser(
      id: mUser.id,
      firstName: mUser.name,
      lastName: "",
      emailAddress: mUser.email,
      photo: mUser.photo,
    );
    Tellam.client().register(tellamUser);

    //
    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.subscribeToTopic(mUser.role);
  }

  //logout
  void logout() async {
    //get current user data
    final currentUser = await appDatabase.userDao.findCurrent();
    //delete current user data from local storage
    appDatabase.userDao.deleteAll();

    _firebaseMessaging.unsubscribeFromTopic("all");
    try {
      _firebaseMessaging.unsubscribeFromTopic(currentUser.role);
    } catch (error) {
      print("Error Unsubscribing user");
    }
    //logout of tellam
    Tellam.client().logout();
  }
}
