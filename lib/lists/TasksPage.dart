import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/AppSidebar.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/lists/TasksList.dart';
import 'package:clean_todo/data/FakeDataGenerator.dart';
import 'package:clean_todo/detail/TaskDetail.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/lists/CTAppBar.dart';
import 'package:clean_todo/lists/MyDayTasksList.dart';

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

      if( categoryName == 'To-Do' ) {
        cache.filterCategory = null;
        cache.showMyDay = false;

      } else if ( categoryName == 'My Day' ) {
        cache.filterCategory = null;
        cache.showMyDay = true;

      } else {
        cache.filterCategory = categoryName;
        cache.showMyDay = false;
      }

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

            isMyDay: cache.showMyDay,
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

    Widget myDayAppBody = new MyDayTasksList(

            todayTasks: cache.todayTasks,
            dueTasks: cache.dueTasks,
            pendingTasks: cache.pendingTasks,
            extraTask: cache.newTask,
            categories: cache.categoryData.user,
            toggleTask: cache.toggleTask,

            updateTask: ( (task){
              this.setState( (){
                cache.updateTask(task);
              });
            }),

            deleteTask: cache.deleteTask,
    );

    Widget listAppBody = new TasksList(

            tasks: cache.tasks,
            extraTask: cache.newTask,
            categories: cache.categoryData.user,
            toggleTask: cache.toggleTask,

            updateTask: ( (task){
              this.setState( (){
                cache.updateTask(task);
              });
            }),

            deleteTask: cache.deleteTask,
    );

    Widget appBody = cache.showMyDay ? myDayAppBody : listAppBody ;

    FloatingActionButton appFab = new FloatingActionButton(

            child: new Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,

            onPressed: (){

              cache.newTask.clear();
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