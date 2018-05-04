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
import 'package:clean_todo/data/DataCache.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  DataCache cache = new DataCache();

  _TasksPageState(){
    DataProvider dataProvider = new FakeDataGenerator();

    if( !cache.isCached ) {
      cache.categoryData = dataProvider.getSidebarData();
      cache.userData = dataProvider.getUserData();
      cache.tasksData = dataProvider.getAllTasks();
      cache.isCached = true;
    }
  }

  filter( String categoryName ){
    this.setState( (){

      if( categoryName == 'To-Do' )
        cache.filterCategory = null;

      else
        cache.filterCategory = categoryName;

    });

    Navigator.pop( context );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> appbar_menu = [];
    if( cache.filterCategory == null )
      appbar_menu.add(
          new IconButton(
            icon: new Icon( Icons.search ),
            onPressed: (){ /* ... todo ... */ },
          )
      );

    else
      appbar_menu.add(
        new PopupMenuButton<String>(
            onSelected: (value) =>  this.setState( (){
              cache.deleteCategory(value);
            }),
            itemBuilder:(BuildContext context) {
              return <PopupMenuEntry<String>>[

                new PopupMenuItem<String>(
                  value: cache.filterCategory,
                  child: new Text('Delete Category'),
                ),

              ];

            })

      );

    return new Scaffold(

      appBar: new AppBar(
        title: cache.filterCategory == null ? new Text(widget.title) : new Text(cache.filterCategory),
        actions: appbar_menu,
      ),

      drawer: new AppSidebar( 
                              categories : cache.categoryData,
                              addCategory : ((newCategory) =>
                                  this.setState( (){
                                    cache.addCategory(newCategory);
                                  })
                              ),
                              filter : filter,
                              userData : cache.userData
              ),

      body: new TasksList( 
        tasks: cache.tasks,
        categories: cache.categoryData.user,
        toggleTask: cache.toggleTask,
        updateTask: cache.updateTask,
        deleteTask: cache.deleteTask,
      ),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context, 
            new MaterialPageRoute(
              builder: (context) => new TaskDetail( 
                                          task: cache.newTask,
                                          updateTask: cache.updateTask,
                                          categories: cache.categoryData.user,
                                        )
            )
          );
        }
      ),
    );
  }
}