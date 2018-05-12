import 'package:flutter/material.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/data/DataProvider.dart';

class DefaultDataGenerator implements DataProvider {

  CategoryData getSidebarData(){

    return new CategoryData(

      system: [
          new Category( id: -1, text: 'My Day', icon: Icons.lightbulb_outline ),
          new Category( id: -2, text: 'To-Do', icon: Icons.check ),
      ],

      user: [
        new Category( text: 'Home' ),
        new Category( text: 'Work' ),
        new Category( text: 'Shopping' ),
      ],

    );

  }

  UserData getUserData(){
    return new UserData( userName: 'Sandra Smith', abbr: 'SS' );
  }

  List<Task> getAllTasks() {
    return [];
  }

}