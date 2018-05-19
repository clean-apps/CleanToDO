import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/data/DefaultDataGenerator.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'dart:async';

class InitManager {

  SettingsManager settings;
  DataCache cache;

  static Future<InitManager> getInstance() async {
    InitManager init = new InitManager();
    init.settings = new SettingsManager();
    init.cache = new DataCache();

    await init.settings.init();
    await init.cache.initDb();

    DataProvider dataProvider = new DefaultDataGenerator();

    init.cache.userData = dataProvider.getUserData();
    init.cache..isCached = true;

    return init;
  }

}