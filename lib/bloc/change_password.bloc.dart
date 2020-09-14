import 'package:flutter/material.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/data/repositories/auth.repository.dart';
import 'package:foodie/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc extends BaseBloc with Validators {
  //Auth repository
  AuthRepository _userRepository = new AuthRepository();

  //view entered data
  //focus node
  FocusNode currentPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmNewPasswordFocusNode = FocusNode();

  //view entered data
  BehaviorSubject<String> _currentPassword = BehaviorSubject<String>();
  BehaviorSubject<String> _newPassword = BehaviorSubject<String>();
  BehaviorSubject<String> _confirmNewPassword = BehaviorSubject<String>();

  //entered data variables getter
  Stream<bool> get validCurrentPassword =>
      _currentPassword.stream.transform(validatePasswordBool);
  Stream<bool> get validNewPassword =>
      _newPassword.stream.transform(validatePasswordBool);
  // Stream<bool> get validConfirmPassword =>
  //     _confirmPassword.stream.transform(validatePasswordBool);
  Stream<String> get validConfirmPassword =>
      _confirmNewPassword.stream.transform(validatePassword).doOnData(
        (String confirmPassword) {
          // If the password is accepted (after validation of the rules)
          // we need to ensure both password and retyped password match
          if (0 != _newPassword.value.compareTo(confirmPassword)) {
            // If they do not match, add an error
            _confirmNewPassword.addError("Password doesn't match");
          }
        },
      );

  Stream<bool> get canUpdate => Rx.combineLatest3(validCurrentPassword,
      validNewPassword, validConfirmPassword, (a, b, c) => true);

  Function(String) get changeCurrentPassword => _currentPassword.add;
  Function(String) get changeNewPassword => _newPassword.add;
  Function(String) get changeConfirmPassword => _confirmNewPassword.add;

  //process update password when user tap on the update button
  void processUpdatePassword() async {
    //update ui state
    setUiState(UiState.loading);

    final resultDialogData = await _userRepository.updatePassword(
      currentPassword: _currentPassword.value,
      newPassword: _newPassword.value,
      confirmNewPassword: _confirmNewPassword.value,
    );

    //update ui state after operation
    setUiState(UiState.done);

    //prepare the data model to be used to show the alert on the view
    dialogData = resultDialogData;
    dialogData.isDismissible = true;
    //notify listners tto show show alert
    setShowDialogAlert(true);
  }
}
