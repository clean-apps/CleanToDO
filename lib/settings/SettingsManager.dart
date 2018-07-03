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

  String get email {
    return prefs.get( "email" );
  }

  set email ( String pTheme ){
    prefs.setString( "email" , pTheme );
  }

  String get username {
    return prefs.get( "username" );
  }

  set username ( String pTheme ){
    prefs.setString( "username" , pTheme );
  }

  bool get showCompleted {
    return prefs.get( "showCompleted" );
  }

  set showCompleted ( bool showCompleted ){
    prefs.setBool( "showCompleted" , showCompleted );
  }

  String get sortString {
    return prefs.get( "sortString" );
  }

  set sortString ( String pSortString ){
    prefs.setString( "sortString" , pSortString );
  }

  set notification_sounds ( bool enable ){
    prefs.setString( "notification_sounds" , enable ? "true" : "false" );
  }

  bool get notification_sounds {
    return prefs.get( "notification_sounds" ) == null ? true :
              prefs.get( "notification_sounds" ).toString() == "true";
  }

  set notification_vibrations ( bool enable ){
    prefs.setString( "notification_vibrations" , enable ? "true" : "false" );
  }

  bool get notification_vibrations {
    return prefs.get( "notification_vibrations" ) == null ? true :
              prefs.get( "notification_vibrations" ).toString() == "true";
  }

  bool get isLoggedIn {
    return prefs.get( "isLoggedIn" ) == null ? false :
              prefs.get( "isLoggedIn" ).toString() == "true";
  }

  set isLoggedIn ( bool pIsLoggedIn ){
    prefs.setString( "isLoggedIn" , pIsLoggedIn ? "true" : "false" );
  }

}