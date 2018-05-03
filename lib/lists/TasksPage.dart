import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/AppSidebar.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/lists/TasksList.dart';
import 'package:clean_todo/data/FakeDataGenerator.dart';
import 'package:clean_todo/detail/TaskDetail.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  
  CategoryData categoryData ;
  UserData userData ;
  List<Task> tasksData ;
  Task newTask ;
  
  _TasksPageState(){
    DataProvider dataProvider = new FakeDataGenerator();

    categoryData = dataProvider.getSidebarData();
    userData = dataProvider.getUserData();
    tasksData = dataProvider.getAllTasks();

    newTask = new Task();
    newTask.id = tasksData.length + 1;
    newTask.completed = false;
  }

  void changeBodyText( newText ){
    //do nothing
  }

  void addCategory( newCategoryLT ){
     this.setState((){
        this.categoryData.user.add(newCategoryLT);
     });
  }


  void toggleTask( Task task ){
    this.setState((){
      tasksData.elementAt( tasksData.indexOf( task ) ).completed = task.completed;
    });
  }
  
  void updateTask( Task task ){
    this.setState((){

      if( tasksData.indexOf( task ) < 0 ){
        task.category = new Category( text: 'Home' );
        tasksData.add( task );

        newTask = new Task();
        newTask.id = tasksData.length + 1;
        newTask.completed = false;
      }

      tasksData.elementAt( tasksData.indexOf( task ) ).title = task.title;
      tasksData.elementAt( tasksData.indexOf( task ) ).category = task.category;
      tasksData.elementAt( tasksData.indexOf( task ) ).deadline_val = task.deadline_val;
      tasksData.elementAt( tasksData.indexOf( task ) ).reminder_date = task.reminder_date;
      tasksData.elementAt( tasksData.indexOf( task ) ).reminder_time = task.reminder_time;
      tasksData.elementAt( tasksData.indexOf( task ) ).completed = task.completed;
    });
  }

  void deleteTask(Task task){
    this.setState((){
      tasksData.remove( task );
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon( Icons.search ),
            onPressed: (){ /* ... todo ... */ },
          )
        ],
      ),

      drawer: new AppSidebar( 
                              categories : categoryData, 
                              addCategory : addCategory,
                              changeBodyText : changeBodyText,
                              userData : userData 
              ),

      body: new TasksList( 
        tasks: tasksData,
        categories: this.categoryData.user,
        toggleTask: toggleTask,
        updateTask: updateTask,
        deleteTask: deleteTask,
      ),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context, 
            new MaterialPageRoute(
              builder: (context) => new TaskDetail( 
                                          task: newTask,
                                          updateTask: updateTask,
                                          categories: this.categoryData.user,
                                        )
            )
          );
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}