import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/calender/DateUtil.dart';
import 'package:clean_todo/data/CategoryProvider.dart';
import 'package:clean_todo/data/CategoryGroupProvider.dart';
import 'package:clean_todo/data/TaskProvider.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:clean_todo/data/NotificationManager.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';
import 'package:clean_todo/data/NotificationManager.dart';

class DataCache {

  CategoryData categoryData = new CategoryData();
  UserData userData = null;
  List<Task> tasksData = [];
  Task newTask = new Task();
  String filterCategory ;
  int filterCategoryId ;
  int filterGroupId ;

  bool isCached = false;

  bool enableSearch = false;
  String searchString = '';

  bool showMyDay = false;
  bool filterGroup = false;
  bool enableQuickAdd = false;

  bool showCompletedTasks = true;

  String sortTasks = "";

  final String dbName = "CleanToDoDB.db";
  TaskProvider taskProvider = new TaskProvider();
  CategoryProvider categoryProvider = new CategoryProvider();
  CategoryGroupProvider categoryGroupProvider = new CategoryGroupProvider();

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

    await notifications.initDb();
    categoryData.user = await categoryProvider.allCategories();
    categoryData.userGroups = await categoryGroupProvider.allCategoryGroups();
    tasksData = await taskProvider.allTasks( categoryData );

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

  List<Task> _filterGroup( List<Task> tasks, int groupId ){

    if( groupId == null )
      return tasks;

    else
      return tasks.where( (task) =>(

              task != null &&
              task.category != null &&
              task.category.groupId == groupId )

      ).toList();
  }

  List<Task> _filterCategories( List<Task> tasks, int categoryId ){

    if( categoryId == null )
      return tasks;

    else
      return tasks.where( (task) =>(

                  task != null &&
                  task.category != null &&
                  task.category.id == categoryId )

              ).toList();
  }

  List<Task> _filterCompleted( List<Task> tasks ){

    if( showCompletedTasks == true )
      return tasks;

    else
      return tasks.where( (task) =>(

              task != null &&
              task.completed != null &&
              task.completed == false )

      ).toList();
  }

  List<Task> _sortTasks( List<Task> tasks ){

    tasks.sort( (task1, task2){

        if( sortTasks == "SORT_BY_CREA" ){
          return task1.id.compareTo(task2.id);

        } else if( sortTasks == "SORT_BY_DUE" ){

          var task1Deadline = "";
          if( task1.deadline_val != null ) task1Deadline = task1.deadline_val;

          var task2Deadline = "";
          if( task2.deadline_val != null ) task2Deadline = task2.deadline_val;

          return task1Deadline.compareTo(task2Deadline);

        } else if( sortTasks == "SORT_BY_ALPHA" ){
          return task1.title.compareTo(task2.title);

        }else if( sortTasks == "SORT_BY_COMPLETED" ){
          return task2.completed.toString().compareTo(task1.completed.toString());

        } else {
          return task1.id.compareTo(task2.id);
        }

      });

    return tasks;
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
                    _filterCategories(
                        _filterGroup( tasksData, filterGroupId ),
                        filterCategoryId ),
                  searchString == null ? searchString : searchString.toLowerCase(),
              );

    else
      return _sortTasks(
                _filterCompleted(
                  _filterCategories(
                      _filterGroup( tasksData, filterGroupId ),
                      filterCategoryId )
                )
      );
  }

  Future<bool> addCategories( List<Category> newCategories ) async {
    await categoryProvider.insertAll(newCategories);
    newCategories.forEach( (newCategory){
      this.categoryData.user.add( newCategory );
    });

    return true;
  }

  addCategoryGroup( CategoryGroup newCategoryGroup ) {
    this.categoryData.userGroups.add( newCategoryGroup );
    categoryGroupProvider.insert( newCategoryGroup );
  }

  addCategory( Category newCategoryLT ) {
    newCategoryLT.id = categoryData.user.last.id + 1;
    this.categoryData.user.add( newCategoryLT );
    categoryProvider.insert( newCategoryLT.clone() );
  }

  deleteCategory( categoryId ) {

    if( categoryId != null ) {

      List<Task> toDelete = [];
      this.tasksData.forEach((task) {
        if (task != null &&
            task.category != null &&
            task.category.id == categoryId)

          toDelete.add(task);
      });

      toDelete.forEach( (task){
        deleteTask(task);
      });

      int indexToDelete = -1;
      this.categoryData.user.asMap().forEach( (i, cat){
        if( cat.id == categoryId ) indexToDelete = i;
      });

      int deleteId = this.categoryData.user[indexToDelete].id;
      this.categoryData.user.removeAt(indexToDelete);
      filterCategory = null;

      categoryProvider.delete( deleteId );
    }

  }

  deleteCategoryGroup( groupId ){

    if( groupId != null ){

      List<Category> toDelete = [];
      this.categoryData.user.forEach( (category){
        if( category != null &&
            category.groupId == groupId){

          toDelete.add(category);
        }
      });

      toDelete.forEach( (category){
        deleteCategory(category.id);
      });

      int indexToDelete = -1;
      this.categoryData.userGroups.asMap().forEach( (i, catGr){
        if( catGr.id == groupId ) indexToDelete = i;
      });

      int deleteId = this.categoryData.userGroups[indexToDelete].id;
      this.categoryData.userGroups.removeAt(indexToDelete);
      filterCategory = null;

      categoryGroupProvider.delete( deleteId );

    }

  }

  updateCategoryName( newValue ){
    var oldValue = filterCategory;

    this.categoryData.user.asMap().forEach( (i, cat){
      if( cat.text == oldValue ) {
        cat.text = newValue;
        categoryProvider.update(cat);
      }
    });

    this.tasksData.forEach((task) {
      if (task != null &&
          task.category != null &&
          task.category.text == oldValue)

        task.category.text = newValue;
        taskProvider.update(task);
    });

    filterCategory = newValue;
  }

  toggleTask( Task task ) {
      tasksData.elementAt( tasksData.indexOf( task ) ).completed = task.completed;
      taskProvider.update(task.clone());
      task.completed ? _update_category_count(task, -1) : _update_category_count(task, 1);
  }

  updateTask( Task task ) {

    if (tasksData.indexOf(task) < 0) {

      Task newTask = task.clone();
      taskProvider.insert(newTask);
      tasksData.add(newTask);

      if( task.repeat != null && task.repeat != RepeatInterval.NONE.index ) {
        notifications.addReminder(newTask);
      }

      _update_category_count(task.clone(), 1);

      newTask = new Task();
      newTask.id = tasksData.length + 1;
      newTask.completed = false;

    } else {

      Task dirtyData = tasksData.elementAt(tasksData.indexOf(task));

      if( dirtyData.completed != task.completed ) {

        if( dirtyData.category.text == task.category.text ) {

          if (task.completed)
            _update_category_count(task, -1);
          else
            _update_category_count(task, 1);

        } else {

          if (task.completed) {
            _update_category_count(task, -1);
            _update_category_count(dirtyData, 1);

          } else {
            _update_category_count(task, 1);
            _update_category_count(dirtyData, -1);
          }

        }
      }

      dirtyData.title = task.title;
      dirtyData.category = task.category;
      dirtyData.deadline_val = task.deadline_val;
      dirtyData.reminder_date = task.reminder_date;
      dirtyData.reminder_time = task.reminder_time;
      dirtyData.completed = task.completed;
      dirtyData.repeat = task.repeat;
      dirtyData.notes = task.notes;

      taskProvider.update(task.clone());

      notifications.cancelReminder(dirtyData);

      if( task.repeat != null && task.repeat != RepeatInterval.NONE.index ) {
        notifications.addReminder(task);
      }
    }

  }

  _update_category_count( Task task, int change ) {

    //print( "category:" + task.category.text + ", change:" + change.toString() );
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