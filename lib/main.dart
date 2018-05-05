import 'package:flutter/material.dart';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/settings/Themes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      theme: Themes.get(null),
      home: new TasksPage(),

    ); 
  }
}
