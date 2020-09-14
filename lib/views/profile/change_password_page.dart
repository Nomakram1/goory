import 'package:flutter/material.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/bloc/change_password.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/general.strings.dart';
import 'package:foodie/constants/strings/profile/change_password.strings.dart';
import 'package:foodie/utils/custom_dialog.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/appbar/leading_app_bar.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/inputs/custom_text_form_field.dart';
import 'package:foodie/widgets/platform/platform_circular_progress_indicator.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //ChangePasswordBloc bloc
  ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();

  @override
  void initState() {
    super.initState();
    //listen to the need to show a dialog alert type
    _changePasswordBloc.showDialogAlert.listen(
      (show) {
        //when asked to show an alert
        if (show) {
          CustomDialog.showAlertDialog(
            context,
            _changePasswordBloc.dialogData,
            isDismissible: _changePasswordBloc.dialogData.isDismissible,
          );
        } else {
          CustomDialog.dismissDialog(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        leading: LeadingAppBar(),
      ),
      body: ListView(
        padding: AppPaddings.defaultPadding(),
        children: <Widget>[
          //header
          Text(
            ChangePasswordStrings.title,
            style: AppTextStyle.h2TitleTextStyle(),
          ),
          UiSpacer.verticalSpace(space: 30),
          //form section
          //current password textformfield
          StreamBuilder<bool>(
            stream: _changePasswordBloc.validCurrentPassword,
            builder: (context, snapshot) {
              return CustomTextFormField(
                hintText: ChangePasswordStrings.currentPassword,
                errorText: snapshot.error,
                togglePassword: true,
                obscureText: true,
                onChanged: _changePasswordBloc.changeCurrentPassword,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          //new password textformfield
          StreamBuilder<bool>(
            stream: _changePasswordBloc.validNewPassword,
            builder: (context, snapshot) {
              return CustomTextFormField(
                hintText: ChangePasswordStrings.newPassword,
                errorText: snapshot.error,
                togglePassword: true,
                obscureText: true,
                onChanged: _changePasswordBloc.changeNewPassword,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          //confirm new password textformfield
          StreamBuilder<String>(
            stream: _changePasswordBloc.validConfirmPassword,
            builder: (context, snapshot) {
              return CustomTextFormField(
                hintText: ChangePasswordStrings.confirmNewPassword,
                errorText: snapshot.error,
                togglePassword: true,
                obscureText: true,
                onChanged: _changePasswordBloc.changeConfirmPassword,
              );
            },
          ),
          UiSpacer.verticalSpace(),

          //update button
          StreamBuilder<bool>(
            stream: _changePasswordBloc.canUpdate,
            builder: (context, snapshot) {
              //need to know if all entry made by the user is valid
              final canUpdate = snapshot.hasData ? snapshot.data : false;
              //listen to the uistate to know the appropriated state to put the register button
              return StreamBuilder<UiState>(
                stream: _changePasswordBloc.uiState,
                builder: (context, snapshot) {
                  final uiState = snapshot.data;

                  return CustomButton(
                    padding: AppPaddings.mediumButtonPadding(),
                    color: AppColor.accentColor,
                    onPressed: (uiState != UiState.loading && canUpdate)
                        ? _changePasswordBloc.processUpdatePassword
                        : null,
                    child: uiState != UiState.loading
                        ? Text(
                            GeneralStrings.update,
                            style: AppTextStyle.h4TitleTextStyle(
                              color: Colors.white,
                            ),
                          )
                        : PlatformCircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
