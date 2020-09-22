import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/bloc/register.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_routes.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/general.strings.dart';
import 'package:Doory/constants/strings/register.strings.dart';
import 'package:Doory/utils/ui_spacer.dart';
import 'package:Doory/widgets/appbar/custom_leading_only_app_bar.dart';
import 'package:Doory/widgets/appbar/empty_appbar.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';
import 'package:Doory/widgets/inputs/custom_text_form_field.dart';
import 'package:Doory/widgets/platform/platform_circular_progress_indicator.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //register bloc
  RegisterBloc _registerBloc = RegisterBloc();
  //name focus node
  final nameFocusNode = new FocusNode();
  //email focus node
  final emailFocusNode = new FocusNode();
  //phone number focus node
  final phoneNumberFocusNode = new FocusNode();
  //password focus node
  final passwordFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    //listen to the need to show a dialog alert or a normal snackbar alert type
    _registerBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        EdgeAlert.show(
          context,
          title: _registerBloc.dialogData.title,
          description: _registerBloc.dialogData.body,
          backgroundColor: _registerBloc.dialogData.backgroundColor,
          icon: _registerBloc.dialogData.iconData,
        );
      }
    });

    //listen to state of the ui
    _registerBloc.uiState.listen((uiState) {
      if (uiState == UiState.redirect) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeRoute,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _registerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: EmptyAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          //body
          ListView(
            children: <Widget>[
              //page intro image
              Hero(
                tag: AppStrings.authImageHeroTag,
                child: Image.asset(
                  AppImages.registerImage,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
              ),

              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: AppPaddings.defaultPadding(),
                children: <Widget>[
                  //page title
                  Text(
                    RegisterStrings.title,
                    style: AppTextStyle.h1TitleTextStyle(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //fullname textformfield
                  StreamBuilder<bool>(
                    stream: _registerBloc.validName,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        hintText: GeneralStrings.fullname,
                        errorText: snapshot.error,
                        textEditingController: _registerBloc.nameTEC,
                        onChanged: _registerBloc.validateName,
                        focusNode: nameFocusNode,
                        nextFocusNode: emailFocusNode,
                        textInputAction: TextInputAction.next,
                      );
                    },
                  ),
                  UiSpacer.verticalSpace(),
                  //email textformfield
                  StreamBuilder<bool>(
                    stream: _registerBloc.validEmailAddress,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        hintText: GeneralStrings.email,
                        errorText: snapshot.error,
                        textEditingController: _registerBloc.emailAddressTEC,
                        focusNode: emailFocusNode,
                        nextFocusNode: phoneNumberFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: _registerBloc.validateEmailAddress,
                      );
                    },
                  ),
                  UiSpacer.verticalSpace(),
                  //phone number textformfield
                  StreamBuilder<bool>(
                    stream: _registerBloc.validPhoneNumber,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        hintText: GeneralStrings.phone,
                        errorText: snapshot.error,
                        textEditingController: _registerBloc.phoneNumberTEC,
                        focusNode: phoneNumberFocusNode,
                        nextFocusNode: passwordFocusNode,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        onChanged: _registerBloc.validatePhone,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //password textformfield
                  StreamBuilder<bool>(
                    stream: _registerBloc.validPassword,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        hintText: GeneralStrings.password,
                        errorText: snapshot.error,
                        togglePassword: true,
                        obscureText: true,
                        textEditingController: _registerBloc.passwordTEC,
                        onChanged: _registerBloc.validatePassword,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //register button
                  //listen to the uistate to know the appropriated state to put the register button
                  StreamBuilder<UiState>(
                    stream: _registerBloc.uiState,
                    builder: (context, snapshot) {
                      final uiState = snapshot.data;

                      return CustomButton(
                        padding: AppPaddings.mediumButtonPadding(),
                        color: AppColor.accentColor,
                        onPressed: uiState != UiState.loading
                            ? _registerBloc.processRegistration
                            : null,
                        child: uiState != UiState.loading
                            ? Text(
                                RegisterStrings.title,
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

          //appbar
          CustomLeadingOnlyAppBar(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
