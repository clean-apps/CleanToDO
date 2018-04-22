import 'package:flutter/material.dart';
import 'package:clean_todo/lists/TasksPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      theme: new ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue
      ),

      home: new TasksPage(title: 'Clean To-Do'),
    ); 
  }
}

