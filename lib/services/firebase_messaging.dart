import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodie/constants/app_routes.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/data/database/app_database_singleton.dart';
import 'package:foodie/data/models/notification_model.dart';

class AppNotification {
  static BuildContext buildContext;
  static NotificationModel notificationModel;

  static setUpFirebaseMessaging() async {
    final appDatabase = AppDatabaseSingleton.database;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    //handling the notification process
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    //Request for notification permission
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");

        //Saving the notification
        notificationModel = NotificationModel();
        notificationModel.title = message["notification"]["title"];
        notificationModel.body = message["notification"]["body"];
        notificationModel.timeStamp = DateTime.now().millisecondsSinceEpoch;
        appDatabase.notificationDao.insertItem(
          notificationModel,
        );

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          AppStrings.appName,
          AppStrings.appName,
          '${AppStrings.appName} Notification Channel',
          importance: Importance.Max,
          priority: Priority.High,
        );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics,
          iOSPlatformChannelSpecifics,
        );
        await flutterLocalNotificationsPlugin.show(
          0,
          notificationModel.title,
          notificationModel.body,
          platformChannelSpecifics,
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    // _firebaseMessaging.onIosSettingsRegistered.listen(
    //   (IosNotificationSettings settings) {
    //     print("Settings registered: $settings");
    //   },
    // );
  }

  static Future selectNotification(String payload) async {
    await Navigator.pushNamed(
      buildContext,
      AppRoutes.notificationsRoute,
    );
  }
}
