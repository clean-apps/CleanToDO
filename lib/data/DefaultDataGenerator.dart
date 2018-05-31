import 'package:flutter/material.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';
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

      userGroups: [
        new CategoryGroup( id: 1, text: 'Personal' ),
        new CategoryGroup( id: 2, text: 'Work' ),
      ],

      user: [
        new Category( id: 1, groupId: 1, text: 'Home', count: 3 ),
        new Category( id: 2, groupId: 1, text: 'Shopping', count: 2 ),
        new Category( id: 3, groupId: 2, text: 'Work', count: 2 ),
      ],

    );

  }

  UserData getUserData(){
    return new UserData( 'Sandra Smith', 'Sandra.Smith@example.com' );
  }

  List<Task> getAllTasks() {
    return [];
  }

}