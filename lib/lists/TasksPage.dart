import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/AppSidebar.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/lists/TasksList.dart';
import 'package:clean_todo/data/FakeDataGenerator.dart';
import 'package:clean_todo/detail/TaskDetail.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/lists/CTAppBar.dart';

class TasksPage extends StatefulWidget {

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

    AppBar appBar = new CTAppBar(

            filterCategory: cache.filterCategory,
            deleteCategory: ((category) =>
                this.setState( (){
                  cache.deleteCategory(category);
                })
            ),

            isSearch: cache.enableSearch,
            toggleSearch: ( (isSearch) =>
                this.setState( (){
                  cache.enableSearch = isSearch;
                  cache.searchString = null;
                })
            ),

            searchString: cache.searchString,
            doSearch: ( (value) =>
                this.setState( (){
                  cache.searchString = value;
                })
            )

    ).build();

    AppSidebar appSidebar = new AppSidebar(

            categories : cache.categoryData,
            addCategory : ((newCategory) =>
                this.setState( (){
                  cache.addCategory(newCategory);
                })
            ),
            filter : filter,
            userData : cache.userData
    );

    Widget appBody = new TasksList(

            tasks: cache.tasks,
            categories: cache.categoryData.user,
            toggleTask: cache.toggleTask,
            updateTask: cache.updateTask,
            deleteTask: cache.deleteTask,
    );

    FloatingActionButton appFab = new FloatingActionButton(

            child: new Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,

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

    );

    return new Scaffold(

      appBar: appBar,
      drawer: appSidebar,
      body: appBody,
      floatingActionButton: appFab,
    );
  }
}