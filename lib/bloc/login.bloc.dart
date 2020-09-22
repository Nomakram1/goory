import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/strings/login.strings.dart';
import 'package:Doory/constants/validation_messages.dart';
import 'package:Doory/data/models/dialog_data.dart';
import 'package:Doory/data/repositories/auth.repository.dart';
import 'package:Doory/utils/validators.dart';
import 'package:Doory/views/auth/facebook_login_webview.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();

  //text editing controller
  TextEditingController emailAddressTEC =
      new TextEditingController(text: "");
  TextEditingController passwordTEC =
      new TextEditingController(text: "");

  //view entered data
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _passwordValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
  Stream<bool> get validEmailAddress => _emailValid.stream;
  Stream<bool> get validPasswordAddress => _passwordValid.stream;

  @override
  void initBloc() {
    super.initBloc();
  }

  //process login when user tap on the login button
  void processLogin() async {
    final email = emailAddressTEC.text;
    final password = passwordTEC.text;

    //check if the user entered email & password are valid
    if (validateEmailAddress(email) && validatePassword(password)) {
      //update ui state
      setUiState(UiState.loading);
      final resultDialogData = await _authRepository.login(
        email: email,
        password: password,
      );

      //update ui state after operation
      setUiState(UiState.done);

      //checking if operation was successful before either showing an error or redirect to home page
      if (resultDialogData.dialogType == DialogType.success) {
        setUiState(UiState.redirect);
      } else {
        //prepare the data model to be used to show the alert on the view
        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
      }
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

  //as user enters password, we are doing password validation
  bool validatePassword(String value) {
    //validating if password, contains at least one uppercase and length is of 6 minimum charater
    if (!Validators.isPasswordValid(value)) {
      _passwordValid.addError(ValidationMessages.invalidPassword);
      return false;
    } else {
      _passwordValid.add(true);
      return true;
    }
  }

  // SOCIAL LOGIN
  //Social Login
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser firebaseUser;

  //facebook
  void signinWithFacebook(BuildContext context) async {
    //facebook client id
   String client_id = "462256824732409";
    //url to redirect to after successful login
    String redirect_url = "https://www.facebook.com/connect/login_success.html";
    //open the facebook login webview
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FacebookLoginWebView(
          selectedUrl:
              'https://www.facebook.com/dialog/oauth?client_id=$client_id&redirect_uri=$redirect_url&response_type=token&scope=email,public_profile,',
        ),
        maintainState: true,
      ),
    );

    //if result was restured
    if (result != null) {
      //show the user a loading state
      setUiState(UiState.loading);

      //try converting facebook accesstoken to an actual firebase user model
      try {
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: result);
        final authResult =
            await _firebaseAuth.signInWithCredential(facebookAuthCred);
        firebaseUser = authResult.user;

        //firebase user must not be an anonymous user
        assert(!firebaseUser.isAnonymous);
        //firebase user must have token id
        assert(await firebaseUser.getIdToken() != null);

        //call socail login request with our gotten access token
        _initiateSocialAccountLogin(firebaseUser: firebaseUser);
      } catch (error) {
        //update ui state after operation
        setUiState(UiState.done);
        //prepare the data model to be used to show the alert on the view
        dialogData.title = "Authenticating";
        final platformExceptionError = error as PlatformException;
        dialogData.body = (platformExceptionError != null &&
                platformExceptionError.message.isNotEmpty)
            ? platformExceptionError.message
            : "There was an error while authenticating your account. Please try again later";
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
      }
    }
  }

  //google login
  void signinWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      //show the user a loading state
      setUiState(UiState.loading);

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      firebaseUser = authResult.user;

      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(firebaseUser.uid == currentUser.uid);
      //firebase user must not be an anonymous user
      assert(!firebaseUser.isAnonymous);
      //firebase user must have token id
      assert(await firebaseUser.getIdToken() != null);

      //call socail login request with our gotten access token
      _initiateSocialAccountLogin(firebaseUser: firebaseUser);
    } on PlatformException catch (error) {
      //update ui state after operation
      setUiState(UiState.done);
      //show dialog with error message
      //prepare the data model to be used to show the alert on the view
      dialogData.title = LoginStrings.processTitle;
      dialogData.body = (error != null && error.message.isNotEmpty)
          ? error.message
          : LoginStrings.processErrorMessage;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      //notify listners to show show alert
      setShowAlert(true);
    } catch (error) {
      //update ui state after operation
      setUiState(UiState.done);
      //show dialog with error message
      dialogData.title = LoginStrings.processTitle;
      dialogData.body = (error != null && error.message.isNotEmpty)
          ? error.message
          : LoginStrings.processErrorMessage;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      //notify listners to show show alert
      setShowAlert(true);
    }
  }

  //send the social profile data over to the server
  void _initiateSocialAccountLogin({
    FirebaseUser firebaseUser,
  }) async {
    //update ui state before operation
    setUiState(UiState.loading);
    final resultDialogData = await _authRepository.loginSocial(
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phone: firebaseUser.phoneNumber,
      password: firebaseUser.uid,
    );

    //update ui state after operation
    setUiState(UiState.done);

    //checking if operation was successful before either showing an error or redirect to home page
    if (resultDialogData.dialogType == DialogType.success) {
      setUiState(UiState.redirect);
    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.title = resultDialogData.title;
      dialogData.body = resultDialogData.body;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      //notify listners tto show show alert
      setShowAlert(true);
    }
  }
}
