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

  bool enableSearch = false;
  String searchString = '';

  DataCache(){
      newTask.id = tasksData.length + 1;
      newTask.completed = false;
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

  void addCategory( newCategoryLT ){
      this.categoryData.user.add( newCategoryLT );
  }

  void deleteCategory( categoryTitle ){

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
    }

  }

  void toggleTask( Task task ){
      tasksData.elementAt( tasksData.indexOf( task ) ).completed = task.completed;
  }

  void updateTask( Task task ) {

    if (tasksData.indexOf(task) < 0) {

      tasksData.add(task.clone());
      _update_category_count(task, 1);

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
    }

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