import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/calender/DateUtil.dart';
import 'package:clean_todo/data/CategoryProvider.dart';
import 'package:clean_todo/data/TaskProvider.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:clean_todo/data/NotificationManager.dart';

class DataCache {

  CategoryData categoryData = new CategoryData();
  UserData userData = null;
  List<Task> tasksData = [];
  Task newTask = new Task();
  String filterCategory ;

  bool isCached = false;

  bool enableSearch = false;
  String searchString = '';

  bool showMyDay = false;
  bool enableQuickAdd = false;

  final String dbName = "CleanToDoDB.db";
  TaskProvider taskProvider = new TaskProvider();
  CategoryProvider categoryProvider = new CategoryProvider();

  NotificationManager notifications = new NotificationManager();

  static Future<DataCache> getInstance() async {
    DataCache cache = new DataCache();
    await cache.initDb();
    return cache;
  }

  DataCache() {
    newTask.id = tasksData.length + 1;
    newTask.completed = false;
  }

  initNotifications( context ){
    notifications.init(context);
  }

  Future<bool> initDb() async {

    tasksData = await taskProvider.allTasks();
    categoryData.user = await categoryProvider.allCategories();

    if( categoryData.user == null || categoryData.user.length == 0 ){

      categoryData.user = [];
      await addCategories(
          [
            new Category( id: 1, text: 'Home', count: 0 ),
            new Category( id: 2, text: 'Work', count: 0 ),
            new Category( id: 3, text: 'Shopping', count: 0 ),
          ]
      );

    }

    categoryData.system = [
      new Category( id: -1, text: 'My Day', icon: Icons.lightbulb_outline ),
      new Category( id: -2, text: 'To-Do', icon: Icons.check )
    ];

    return true;
  }

  List<Task> _filterCategories( List<Task> tasks, String category ){

    if( filterCategory == null )
      return tasks;

    else
      return tasks.where( (task) =>(

                  task != null &&
                  task.category != null &&
                  task.category.text == filterCategory )

              ).toList();
  }

  List<Task> _filterSearch( List<Task> tasks, String search ){

    if( search == null )
      return tasks;

    else
      return tasks.where( (task) => (

                  task != null &&
                  task.title != null &&
                  task.title.toLowerCase().contains(search) )

              ).toList();
  }

  List<Task> get tasks {

    if( enableSearch )
      return _filterSearch(
                  _filterCategories( tasksData, filterCategory ),
                  searchString == null ? searchString : searchString.toLowerCase(),
              );

    else
      return _filterCategories( tasksData, filterCategory );
  }

  Future<bool> addCategories( List<Category> newCategories ) async {
    await categoryProvider.insertAll(newCategories);
    newCategories.forEach( (newCategory){
      this.categoryData.user.add( newCategory );
    });

    return true;
  }

  addCategory( Category newCategoryLT ) {
    newCategoryLT.id = categoryData.user.last.id + 1;
    this.categoryData.user.add( newCategoryLT );
    categoryProvider.insert( newCategoryLT.clone() );
  }

  deleteCategory( categoryTitle ) {

    if( categoryTitle != null ) {

      List<Task> toDelete = [];
      this.tasksData.forEach((task) {
        if (task != null &&
            task.category != null &&
            task.category.text == categoryTitle)

          toDelete.add(task);
      });

      toDelete.forEach( (task){
        deleteTask(task);
      });

      int indexToDelete = -1;
      this.categoryData.user.asMap().forEach( (i, cat){
        if( cat.text == categoryTitle ) indexToDelete = i;
      });

      this.categoryData.user.removeAt(indexToDelete);
      filterCategory = null;

      categoryProvider.delete( this.categoryData.user[indexToDelete].id );
    }

  }

  toggleTask( Task task ) {
      tasksData.elementAt( tasksData.indexOf( task ) ).completed = task.completed;
      taskProvider.update(task.clone());
  }

  updateTask( Task task ) {

    if (tasksData.indexOf(task) < 0) {

      Task newTask = task.clone();
      taskProvider.insert(newTask);
      tasksData.add(newTask);
      notifications.addReminder( newTask );
      _update_category_count(task.clone(), 1);

      newTask = new Task();
      newTask.id = tasksData.length + 1;
      newTask.completed = false;

    } else {

      Task dirtyData = tasksData.elementAt(tasksData.indexOf(task));

      if (dirtyData.category == null && task.category != null) {
        _update_category_count(task, 1);

      } else if (dirtyData.category == null && task.category == null) {
        _update_category_count(dirtyData, -1);

      } else if (dirtyData.category.text != task.category.text) {
        _update_category_count(dirtyData, -1);
        _update_category_count(task, 1);

      }

      dirtyData.title = task.title;
      dirtyData.category = task.category;
      dirtyData.deadline_val = task.deadline_val;
      dirtyData.reminder_date = task.reminder_date;
      dirtyData.reminder_time = task.reminder_time;
      dirtyData.completed = task.completed;
      dirtyData.notes = task.notes;

      taskProvider.update(task.clone());
      notifications.updateReminder( newTask );
    }

  }

  _update_category_count( Task task, int change ) {

    categoryData.user.forEach(  (category) {
      if( category.text == task.category.text ) {
          category.count += change;
          categoryProvider.update(category.clone());
        }
      }
    );

  }

  deleteTask(Task task) {
    tasksData.remove( task );
    taskProvider.delete( task.id );
    notifications.cancelReminder( newTask );
    _update_category_count( task.clone(), -1 );

  }

  List<Task> get todayTasks {
    return tasksData
        .where( (task) => task.deadline_val == DateUtil.parse( DateUtil.today ) )
        .toList();

  }

  List<Task> get dueTasks {
    return tasksData
              .where( (task) => task.isDue && task.deadline_val != DateUtil.parse( DateUtil.today ) )
              .toList();

  }

  List<Task> get pendingTasks {

    return tasksData
              .where( (task) => !task.isDue && !task.completed )
              .toList();

  }

  bool get showFab {
    return isCached && filterCategory != null ;
  }

}