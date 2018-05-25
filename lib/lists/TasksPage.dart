import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/AppSidebar.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/lists/TasksList.dart';
import 'package:clean_todo/data/DefaultDataGenerator.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/lists/CTAppBar.dart';
import 'package:clean_todo/lists/MyDayTasksList.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/detail/TaskDetail.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/settings/Themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  SettingsManager settings;
  DataCache cache;

  TasksPage({this.settings, this.cache});

  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  filter( String categoryName ){
    this.setState( (){

      if( categoryName == 'To-Do' ) {
        widget.cache.filterCategory = null;
        widget.cache.showMyDay = false;

      } else if ( categoryName == 'My Day' ) {
        widget.cache.filterCategory = null;
        widget.cache.showMyDay = true;

      } else {
        widget.cache.filterCategory = categoryName;
        widget.cache.showMyDay = false;
      }

    });

    Navigator.pop( context );
  }

  @override
  Widget build(BuildContext context) {

    widget.cache.initNotifications(context);

    AppBar appBar = new CTAppBar(

            filterCategory: widget.cache.filterCategory,
            deleteCategory: ((category) =>
                this.setState( (){
                  widget.cache.deleteCategory(category);
                  widget.cache.filterCategory = null;
                })
            ),

            isMyDay: widget.cache.showMyDay,
            isSearch: widget.cache.enableSearch,
            toggleSearch: ( (isSearch) =>
                this.setState( (){
                  widget.cache.enableSearch = isSearch;
                  widget.cache.searchString = null;
                })
            ),

            searchString: widget.cache.searchString,
            doSearch: ( (value) =>
                this.setState( (){
                  widget.cache.searchString = value;
                })
            ),

            themeColor: widget.settings.theme == null ? 'blue' : widget.settings.theme,
            updateColor: ( (value) =>
                this.setState( (){
                  widget.settings.theme = value;
                })
            ),

            isShowCompletedTasks: widget.cache.showCompletedTasks,
            updateShowCompletedTasks: ((value) =>
                this.setState( (){
                  widget.cache.showCompletedTasks = value;
                })
            ),

            updateSortTasks: ((value) =>
                this.setState((){
                  widget.cache.sortTasks = value;
                })
            ),

            updateCategoryName: ((newValue) =>
                this.setState((){
                  widget.cache.updateCategoryName(newValue);
                })
            ),

    ).build(context);

    AppSidebar appSidebar = new AppSidebar(

            categories : widget.cache.categoryData,
            addCategory : ((newCategory) =>
                this.setState( (){
                  widget.cache.addCategory(newCategory);
                })
            ),
            filter : filter,
            userData : widget.cache.userData
    );

    Widget myDayAppBody = new MyDayTasksList(

            todayTasks: widget.cache.todayTasks,
            dueTasks: widget.cache.dueTasks,
            pendingTasks: widget.cache.pendingTasks,
            extraTask: widget.cache.newTask,
            categories: widget.cache.categoryData.user,
            toggleTask: widget.cache.toggleTask,

            updateTask: ( (task){
              this.setState( (){
                widget.cache.updateTask(task);
              });
            }),

            deleteTask: widget.cache.deleteTask,
    );

    Widget listAppBody = new TasksList(

            tasks: widget.cache.tasks,
            extraTask: widget.cache.newTask,
            categories: widget.cache.categoryData.user,
            toggleTask: widget.cache.toggleTask,

            updateTask: ( (task){
              this.setState( (){
                widget.cache.updateTask(task);
              });
            }),

            deleteTask: widget.cache.deleteTask,
    );

    Widget appBody = widget.cache.showMyDay ? myDayAppBody : listAppBody ;

    FloatingActionButton appFabFilter = new FloatingActionButton(

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
                                        widget.cache.newTask.clear();
                                        widget.cache.newTask.id = widget.cache.tasksData.length + 1;
                                        widget.cache.newTask.title = value;
                                        widget.cache.newTask.category = new Category(text: widget.cache.filterCategory);
                                        widget.cache.updateTask(widget.cache.newTask);
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
                                          widget.cache.newTask.clear();
                                          widget.cache.newTask.id = widget.cache.tasksData.length + 1;
                                          widget.cache.newTask.title = tecNewTask.text;
                                          widget.cache.newTask.category = new Category(text: widget.cache.filterCategory);
                                          widget.cache.updateTask(widget.cache.newTask);
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

    FloatingActionButton appFabGeneric = new FloatingActionButton(

        child: new Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,

        onPressed: (){

          widget.cache.newTask.clear();
          widget.cache.newTask.id = widget.cache.tasksData.length + 1;

          Navigator.push(
              context,
              new MaterialPageRoute( builder: (context) =>
                  new TaskDetail(
                    task: widget.cache.newTask,
                    categories: widget.cache.categoryData.user,
                    updateTask: (task){
                      widget.cache.updateTask(task);
                    },
                  )
              )
          );

        }

    );

    FloatingActionButton appFab = widget.cache.showMyDay ? null : ( widget.cache.filterCategory == null ? appFabGeneric : appFabFilter );

    return new Scaffold(
      appBar: appBar,
      drawer: appSidebar,
      body: appBody,
      floatingActionButton: appFab,
    );
  }
}