import 'package:flutter/material.dart';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/settings/Themes.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/InitManager.dart';
import 'package:clean_todo/data/DataCache.dart';

void main() => runApp(

  new FutureBuilder(

      future: InitManager.getInstance(),

      builder: (_, snapshot) {
        return snapshot.hasData ?
          new MyApp( settings: snapshot.data.settings, cache: snapshot.data.cache ) :
          new Container(width: 0.0, height: 0.0) ;
      }

  )

);

class MyApp extends StatelessWidget {

  DataCache cache;
  SettingsManager settings;

  MyApp({this.settings, this.cache});

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      theme: Themes.get( settings.theme ),
      home: new TasksPage(settings: this.settings, cache: this.cache),

    );
  }
}
