import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/bloc/forgot_password.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/forgot_password.strings.dart';
import 'package:Doory/constants/strings/general.strings.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';
import 'package:Doory/widgets/inputs/custom_text_form_field.dart';
import 'package:Doory/widgets/platform/platform_circular_progress_indicator.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //forgotpassword bloc
  ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  //email focus node
  final emailFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    //listen to the need to show a dialog alert or a normal snackbar alert type
    _forgotPasswordBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        EdgeAlert.show(
          context,
          title: _forgotPasswordBloc.dialogData.title,
          description: _forgotPasswordBloc.dialogData.body,
          backgroundColor: _forgotPasswordBloc.dialogData.backgroundColor,
          icon: _forgotPasswordBloc.dialogData.iconData,
          duration: EdgeAlert.LENGTH_VERY_LONG,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          //page intro image
          Hero(
            tag: AppStrings.authImageHeroTag,
            child: Image.asset(
              AppImages.forgotPasswordImage,
            ),
          ),

          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: AppPaddings.defaultPadding(),
            children: <Widget>[
              //page title
              Text(
                ForgotPasswordStrings.title,
                style: AppTextStyle.h1TitleTextStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                ForgotPasswordStrings.instruction,
              ),
              SizedBox(
                height: 30,
              ),
              //email textformfield
              StreamBuilder<bool>(
                stream: _forgotPasswordBloc.validEmailAddress,
                builder: (context, snapshot) {
                  return CustomTextFormField(
                    textEditingController: _forgotPasswordBloc.emailAddressTEC,
                    hintText: GeneralStrings.email,
                    errorText: snapshot.error,
                    onChanged: _forgotPasswordBloc.validateEmailAddress,
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              //reset password button
              StreamBuilder<UiState>(
                stream: _forgotPasswordBloc.uiState,
                builder: (context, snapshot) {
                  final uiState = snapshot.data;
                  return CustomButton(
                    padding: AppPaddings.mediumButtonPadding(),
                    color: AppColor.accentColor,
                    onPressed: uiState != UiState.loading
                        ? _forgotPasswordBloc.processPasswordReset
                        : null,
                    child: uiState != UiState.loading
                        ? Text(
                            ForgotPasswordStrings.buttonTitle,
                            style: AppTextStyle.h4TitleTextStyle(
                              color: Colors.white,
                            ),
                          )
                        : PlatformCircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
