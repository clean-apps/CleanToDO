import 'package:flutter/material.dart';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/settings/Themes.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/InitManager.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/settings/LoginScreen.dart';
import 'package:clean_todo/settings/SplashScreen.dart';

/*
void main() => runApp(

    new FutureBuilder(

        future: InitManager.getInstance(),

        builder: (_, snapshot) {
          return snapshot.hasData ?
            new LoginScreen( settings: snapshot.data.settings, cache: snapshot.data.cache ) :
            new SplashScreen() ;
        }

    )

);
*/

void main() => runApp(

  new FutureBuilder(

      future: InitManager.getInstance(),

      builder: (_, snapshot) {
        return snapshot.hasData ?
          (
              snapshot.data.isSignedIn ?
                new CleanToDoApp( settings: snapshot.data.settings, cache: snapshot.data.cache ) :
                new LoginScreen( settings: snapshot.data.settings, cache: snapshot.data.cache )
          ) :
          new SplashScreen() ;
      }
  )
);

class CleanToDoApp extends StatelessWidget {

  DataCache cache;
  SettingsManager settings;

  CleanToDoApp({this.settings, this.cache});

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      //theme: Themes.get( AppColors.BLACK ),
      theme: Themes.get( settings.theme ),
      home: new TasksPage(settings: this.settings, cache: this.cache),

    );
  }
}


