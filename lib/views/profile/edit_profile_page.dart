import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/bloc/edit_profile.bloc.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/general.strings.dart';
import 'package:foodie/constants/strings/profile/update.strings.dart';
import 'package:foodie/data/models/user.dart';
import 'package:foodie/utils/custom_dialog.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/appbar/leading_app_bar.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';
import 'package:foodie/widgets/inputs/custom_text_form_field.dart';
import 'package:foodie/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:foodie/widgets/profile/user_profile_photo.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //EditProfileBloc Instance
  final EditProfileBloc _editProfileBloc = EditProfileBloc();

  @override
  void initState() {
    super.initState();
    _editProfileBloc.initBloc();
    //listen to the need to show a dialog alert type
    _editProfileBloc.showDialogAlert.listen(
      (show) {
        //when asked to show an alert
        if (show) {
          CustomDialog.showAlertDialog(
            context,
            _editProfileBloc.dialogData,
            isDismissible: _editProfileBloc.dialogData.isDismissible,
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
            UpdateProfileStrings.title,
            style: AppTextStyle.h2TitleTextStyle(),
          ),
          UiSpacer.verticalSpace(space: 40),

          //form section
          //profile picture
          Center(
            child: StreamBuilder<User>(
              stream:
                  _editProfileBloc.appDatabase.userDao.findCurrentAsStream(),
              builder: (context, snapshot) {
                //get the current user for future ref
                //check if user as selected a new profile picture
                final profileImageUrl =
                    snapshot.hasData ? snapshot.data.photo : "";

                //else show the current user profile photo
                return StreamBuilder<File>(
                  stream: _editProfileBloc.profilePhoto,
                  builder: (context, snapshot) {
                    return UserProfilePhoto(
                      userProfileImageUrl: profileImageUrl,
                      isFile: snapshot.hasData,
                      userProfileImage: snapshot.data,
                    );
                  },
                );
              },
            ),
          ),
          UiSpacer.verticalSpace(space: 10),
          //edit button
          Center(
            child: CustomButton(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              color: AppColor.primaryColor,
              child: Text(
                UpdateProfileStrings.changePhoto,
                style: AppTextStyle.h5TitleTextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: _editProfileBloc.pickNewProfilePhoto,
            ),
          ),
          UiSpacer.verticalSpace(space: 30),

          //name textformfield
          StreamBuilder<bool>(
            stream: _editProfileBloc.validName,
            builder: (context, snapshot) {
              return CustomTextFormField(
                isFixedHeight: false,
                labelText: GeneralStrings.fullname,
                errorText: snapshot.error,
                onChanged: _editProfileBloc.validateName,
                textEditingController: _editProfileBloc.nameTEC,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          //email textformfield
          StreamBuilder<bool>(
            stream: _editProfileBloc.validEmailAddress,
            builder: (context, snapshot) {
              return CustomTextFormField(
                isFixedHeight: false,
                labelText: GeneralStrings.email,
                errorText: snapshot.error,
                onChanged: _editProfileBloc.validateEmailAddress,
                textEditingController: _editProfileBloc.emailAddressTEC,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          //phone textformfield
          StreamBuilder<bool>(
            stream: _editProfileBloc.validPhoneNumber,
            builder: (context, snapshot) {
              return CustomTextFormField(
                isFixedHeight: false,
                labelText: GeneralStrings.phone,
                errorText: snapshot.error,
                onChanged: _editProfileBloc.validatePhoneNumber,
                textEditingController: _editProfileBloc.phoneNumberTEC,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          //update button
          StreamBuilder<UiState>(
            stream: _editProfileBloc.uiState,
            builder: (context, snapshot) {
              final uiState = snapshot.data;

              return CustomButton(
                padding: AppPaddings.mediumButtonPadding(),
                color: AppColor.accentColor,
                onPressed: uiState != UiState.loading
                    ? _editProfileBloc.processAccountUpdate
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
          ),
        ],
      ),
    );
  }
}
