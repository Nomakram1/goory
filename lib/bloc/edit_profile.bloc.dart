import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/constants/validation_messages.dart';
import 'package:foodie/data/repositories/auth.repository.dart';
import 'package:foodie/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc extends BaseBloc {
  //auth repository
  AuthRepository _authRepository = AuthRepository();

  //text editing controller
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController emailAddressTEC = new TextEditingController();
  TextEditingController phoneNumberTEC = new TextEditingController();

  //view entered data
  BehaviorSubject<File> _profilePhoto = BehaviorSubject<File>();
  BehaviorSubject<bool> _nameValid = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> _phoneNumberValid = BehaviorSubject<bool>.seeded(true);

  //entered data variables getter
  Stream<File> get profilePhoto => _profilePhoto.stream;
  Stream<bool> get validName => _nameValid.stream;
  Stream<bool> get validEmailAddress => _emailValid.stream;
  Stream<bool> get validPhoneNumber => _phoneNumberValid.stream;

  @override
  void initBloc() async {
    super.initBloc();
    final currentUser = await appDatabase.userDao.findCurrent();
    nameTEC.text = currentUser.name;
    emailAddressTEC.text = currentUser.email;
    phoneNumberTEC.text = currentUser.phone;
    print("Phone ==> ${currentUser.phone}");
  }

  //pick new profile
  void pickNewProfilePhoto() async {
    try {
      File image = await FilePicker.getFile(type: FileType.image);
      _profilePhoto.add(image);
    } catch (error) {
      print("Error picking profile photo");
      _profilePhoto.addError(error);
    }
  }

  //as user enters name, we are doing name validation, error if its empty of less than 3 words
  bool validateName(String value) {
    if (value.isEmpty || value.length < 3) {
      _nameValid.addError(ValidationMessages.invalidName);
      return false;
    } else {
      _nameValid.add(true);
      return true;
    }
  }

  //as user enters email, we are doing email validation
  bool validateEmailAddress(String value) {
    if (!Validators.isEmailValid(value)) {
      _emailValid.addError(ValidationMessages.invalidEmail);
      return false;
    } else {
      _emailValid.add(true);
      return true;
    }
  }

  //as user enters email, we are doing email validation
  bool validatePhoneNumber(String value) {
    if (!Validators.isPhoneNumberValid(value)) {
      _phoneNumberValid.addError(ValidationMessages.invalidPhoneNumber);
      return false;
    } else {
      _phoneNumberValid.add(true);
      return true;
    }
  }

  //process login when user tap on the login button
  void processAccountUpdate() async {
    //get the entered value from the text editing controller
    final name = nameTEC.text;
    final email = emailAddressTEC.text;
    final phone = phoneNumberTEC.text;

    //check if the user entered name & email are valid
    if (validateName(name) &&
        validateEmailAddress(email) &&
        validatePhoneNumber(phone)) {
      //update ui state
      setUiState(UiState.loading);

      //check if user changed profile picture
      var newProfilePhotoUrl = "";
      if (_profilePhoto.hasValue) {
        //generating a file name for the new profile picture
        final currentUser = await appDatabase.userDao.findCurrent();
        //adding the file extension
        final profileFileName = "user_${currentUser.id}_.png";
        newProfilePhotoUrl = await _updateProfilePhoto(
          _profilePhoto.value,
          profileFileName,
        );
      }

      //make the request to the server
      final resultDialogData = await _authRepository.updateProfile(
        name: name,
        email: email,
        phone: phone,
        photo: newProfilePhotoUrl,
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

  //upload the selected profile photo to firebase storage
  Future<String> _updateProfilePhoto(File file, String filename) async {
    //get storage reference
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
          "images/profile/$filename",
        );
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String imageUrl = (await downloadUrl.ref.getDownloadURL());
    return imageUrl;
  }
}
