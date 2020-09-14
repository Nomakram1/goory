import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/validation_messages.dart';
import 'package:foodie/data/models/dialog_data.dart';
import 'package:foodie/data/repositories/auth.repository.dart';
import 'package:foodie/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();

  //text editing controller
  TextEditingController emailAddressTEC =
      new TextEditingController(text: "client@demo.com");

  //view entered data
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
  Stream<bool> get validEmailAddress => _emailValid.stream;

  @override
  void initBloc() {
    super.initBloc();
  }

  //process login when user tap on the login button
  void processPasswordReset() async {
    final email = emailAddressTEC.text;

    //check if the user entered email is valid
    if (validateEmailAddress(email)) {
      //update ui state
      setUiState(UiState.loading);
      final resultDialogData = await _authRepository.resetPassword(
        email: email,
      );

      //update ui state after operation
      setUiState(UiState.done);

      //checking if operation was successful before either showing an error or success alert
      //prepare the data model to be used to show the alert on the view
      dialogData.title = resultDialogData.title;
      dialogData.body = resultDialogData.body;
      dialogData.backgroundColor =
          resultDialogData.dialogType != DialogType.success
              ? AppColor.failedColor
              : AppColor.successfulColor;
      dialogData.iconData = resultDialogData.dialogType != DialogType.success
          ? FlutterIcons.error_mdi
          : FlutterIcons.check_box_mdi;
      //notify listners tto show show alert
      setShowAlert(true);
    }
  }

  //as user enters email address, we are doing email validation
  bool validateEmailAddress(String value) {
    if (!Validators.isEmailValid(value)) {
      _emailValid.addError(ValidationMessages.invalidEmail);
      return false;
    } else {
      _emailValid.add(true);
      return true;
    }
  }
}
