import 'package:flutter/material.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/data/DataProvider.dart';

class FakeDataGenerator implements DataProvider {

  CategoryData getSidebarData(){

    return new CategoryData(

      system: [
          new Category( text: 'My Day', icon: Icons.lightbulb_outline ),
          new Category( text: 'To-Do', icon: Icons.check ),
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

  List<Task> getAllTasks(){
    return [
      new Task( id : 0, completed : true, title: 'fix the lightbulb', category: new Category( text: 'Home' ) , deadline: 'tomorrow', reminder: 'morning', notes:  'yes' ),
      new Task( id : 1, completed : false, title: 'clean the garden', category: new Category( text: 'Home' ) ),
      new Task( id : 2, completed : false, title: 'fix the fire hose', category: new Category( text: 'Home' ), deadline: 'next week', reminder: 'morning' ),
      new Task( id : 3, completed : true, title: 'finish the annual reports', category: new Category( text: 'Work' ) ),
      new Task( id : 4, completed : false, title: 'come up with ideas for the pre-sales task', category: new Category( text: 'Work' ), deadline: 'next week' ),
      new Task( id : 5, completed : false, title: 'buy ring for aniversary', category: new Category( text: 'Shopping' ) ),
      new Task( id : 6, completed : false, title: 'buy shirts for presentation', category: new Category( text: 'Shopping' ), reminder: 'morning' ),
    ];
  }

}