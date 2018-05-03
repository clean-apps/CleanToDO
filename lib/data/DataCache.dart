import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/Task.dart';

class DataCache {

  CategoryData categoryData = new CategoryData();
  UserData userData = new UserData();
  List<Task> tasksData = [];
  Task newTask = new Task();
  String filterCategory ;

  bool isCached = false;

  DataCache(){
      newTask.id = tasksData.length + 1;
      newTask.completed = false;
  }

  List<Task> get tasks {
    if( filterCategory == null )
      return tasksData;

    else
      return tasksData.where( (task) =>
                ( task != null &&
                  task.category != null &&
                  task.category.text == filterCategory )

              ).toList();
  }

  void addCategory( newCategoryLT ){
      this.categoryData.user.add( newCategoryLT );
  }

  void toggleTask( Task task ){
      tasksData.elementAt( tasksData.indexOf( task ) ).completed = task.completed;
  }

  void updateTask( Task task ){

      if( tasksData.indexOf( task ) < 0 ){
        task.category = new Category( text: 'Home' );
        tasksData.add( task );

        newTask = new Task();
        newTask.id = tasksData.length + 1;
        newTask.completed = false;
      }

      Task dirtyData = tasksData.elementAt( tasksData.indexOf( task ) );

      if( dirtyData.category == null && task.category != null )
        _update_category_count( task, 1 );

      else if( dirtyData.category == null && task.category == null )
        _update_category_count( dirtyData, -1 );

      else if( dirtyData.category.text != task.category.text )
        _update_category_count( dirtyData, -1 );
        _update_category_count( task, 1 );

      dirtyData.title = task.title;
      dirtyData.category = task.category;
      dirtyData.deadline_val = task.deadline_val;
      dirtyData.reminder_date = task.reminder_date;
      dirtyData.reminder_time = task.reminder_time;
      dirtyData.completed = task.completed;

      _update_category_count( task, 1 );
  }

  void _update_category_count( Task task, int change ){

    categoryData.user.forEach(  (category){
      if( category.text == task.category.text )
        category.count += change;
    });

  }

  void deleteTask(Task task){
    tasksData.remove( task );
    _update_category_count( task, -1 );

  }
}