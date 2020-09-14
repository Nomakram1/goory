import 'dart:async';

import 'package:foodie/data/database/app_database.dart';

class AppDatabaseSingleton {
  static AppDatabase database;

  Future<AppDatabase> prepareDatabase() async {
    if (database != null) return database;
    database = await $FloorAppDatabase.databaseBuilder('foodie.db').build();
    return database;
  }
}
