import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/AppSidebar.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/lists/TasksList.dart';
import 'package:clean_todo/data/DefaultDataGenerator.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/lists/CTAppBar.dart';
import 'package:clean_todo/lists/MyDayTasksList.dart';
import 'package:clean_todo/beans/Category.dart';

class _SystemPadding extends StatelessWidget {

  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class TasksPage extends StatefulWidget {

  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  DataCache cache = new DataCache();

  _TasksPageState(){
    DataProvider dataProvider = new DefaultDataGenerator();

    cache.initDb().then((finished){
      this.setState((){
        cache.userData = dataProvider.getUserData();
        cache.isCached = true;
      });
    });

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

              TextEditingController tecNewTask = new TextEditingController();
              showModalBottomSheet<void>(

                  context: context,
                  builder: (BuildContext context){
                      return new _SystemPadding(
                        child: new Container(
                          child: new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new ListTile(
                                leading: new Icon( Icons.radio_button_unchecked, size: 28.0, color: Theme.of(context).primaryColor, ),
                                title: new TextField(
                                  autofocus: true,
                                  controller: tecNewTask,
                                  decoration: new InputDecoration(
                                    hintText: 'Add a to-do',
                                    hintStyle: new TextStyle( color: Colors.grey ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value){
                                    if( value != null && value.length > 0 ) {
                                      this.setState(() {
                                        cache.newTask.clear();
                                        cache.newTask.id = cache.tasksData.length + 1;
                                        cache.newTask.title = value;
                                        cache.newTask.category = new Category(text: cache.filterCategory);
                                        cache.updateTask(cache.newTask);
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                ),
                                trailing: new IconButton(
                                    icon: new CircleAvatar(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      child: new Icon( Icons.keyboard_arrow_right),
                                    ),
                                    onPressed: (){

                                      if( tecNewTask.text != null && tecNewTask.text.length > 0 ) {
                                        this.setState(() {
                                          cache.newTask.clear();
                                          cache.newTask.id = cache.tasksData.length + 1;
                                          cache.newTask.title = tecNewTask.text;
                                          cache.newTask.category = new Category(text: cache.filterCategory);
                                          cache.updateTask(cache.newTask);
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                ),
                              )
                          )

                        )
                      );
                  },
              );

            }

    );

    return new Scaffold(

      appBar: cache.isCached ? appBar : null,
      drawer: cache.isCached ? appSidebar : null,
      body: appBody,
      floatingActionButton: cache.showFab ? appFab : null,

    );
  }
}