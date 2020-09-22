import 'dart:async';

import 'package:Doory/data/database/app_database.dart';

class AppDatabaseSingleton {
  static AppDatabase database;

  Future<AppDatabase> prepareDatabase() async {
    if (database != null) return database;
    database = await $FloorAppDatabase.databaseBuilder('Doory.db').build();
    return database;
  }
}
