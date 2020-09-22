import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/data/database/app_database_singleton.dart';
import 'package:Doory/services/firebase_messaging.dart';
import 'package:Doory/utils/router.dart' as router;
import 'package:Doory/views/auth/onboarding_page.dart';
import 'package:Doory/views/home_page.dart';
import 'package:tellam/tellam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize App Database
  await AppDatabaseSingleton().prepareDatabase();
  //start notification listening
  AppNotification.setUpFirebaseMessaging();

  //initiating tellam
  Tellam.initialize(
    databaseUrl: "https://flutter-projects-5ec90-ba266.firebaseio.com/",
    uiconfiguration: UIConfiguration(
      accentColor: AppColor.accentColor,
      primaryColor: AppColor.primaryColor,
      primaryDarkColor: AppColor.primaryColorDark,
      buttonColor: AppColor.accentColor,
    ),
  );

  //clear user records if any
  // await AppDatabaseSingleton.database.userDao.deleteAll();
  // await AppDatabaseSingleton.database.productDao.deleteAll();
  // await AppDatabaseSingleton.database.productExtraDao.deleteAll();

  // Set default home.
  Widget _startPage = new OnboardingPage();

  //check if user has signin before
  final user = await AppDatabaseSingleton.database.userDao.findCurrent();
  if (user != null) {
    _startPage = HomePage();
  }

  // Run app!
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      onGenerateRoute: router.generateRoute,
      home: _startPage,
      theme: ThemeData(
        accentColor: AppColor.accentColor,
        primaryColor: AppColor.primaryColor,
        primaryColorDark: AppColor.primaryColorDark,
        cursorColor: AppColor.cursorColor,
      ),
    ),
  );
}
