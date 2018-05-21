import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingsManager {

  SharedPreferences prefs ;

  static Future<SettingsManager> getInstance() async {
    SettingsManager newSM = new SettingsManager();
    newSM.prefs = await SharedPreferences.getInstance();
    return newSM;
  }

  Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  String get theme {
    return prefs.get( "theme" );
  }

  set theme ( String pTheme ){
    prefs.setString( "theme" , pTheme );
  }

  String get username {
    return prefs.get( "username" );
  }

  set username ( String pTheme ){
    prefs.setString( "username" , pTheme );
  }

}