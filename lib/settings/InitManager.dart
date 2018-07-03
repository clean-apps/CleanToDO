import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/data/DefaultDataGenerator.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'dart:async';
import 'package:clean_todo/data/FakeDataGenerator.dart';

class InitManager {

  SettingsManager settings;
  DataCache cache;

  static Future<InitManager> getInstance() async {
    InitManager init = new InitManager();
    init.settings = new SettingsManager();
    init.cache = new DataCache();

    await init.settings.init();
    await init.cache.initDb( init.settings.showCompleted );

    if( init.settings.showCompleted != null ) {
      init.cache.showCompletedTasks = init.settings.showCompleted;

    } else {
      init.cache.showCompletedTasks = true;

    }

    if( init.settings.sortString != null ) {
      init.cache.sortTasks = init.settings.sortString;

    } else {
      init.cache.sortTasks = 'SORT_BY_CREA';

    }

    if( init.isSignedIn ) {
      init.cache.userData = new UserData(init.settings.username, init.settings.email);

    } else {
      DataProvider provider = new DefaultDataGenerator();
      init.cache.userData = provider.getUserData();
    }

    init.cache.isCached = true;
    bool demoMode = false;

    if( demoMode ) {
      DataProvider mockProvider = new FakeDataGenerator();
      init.cache.tasksData = mockProvider.getAllTasks();
      init.cache.userData = mockProvider.getUserData();
      init.cache.categoryData = mockProvider.getSidebarData();
    }

    return init;
  }

  bool get isSignedIn {
    return (
              ( settings.username != null && settings.username.length > 0 ) ||
              settings.isLoggedIn
    );
  }

}