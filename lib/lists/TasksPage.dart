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
import 'package:clean_todo/lists/TasksList.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/styles/AppIcons.dart';
import 'package:clean_todo/main.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';
import 'package:clean_todo/lists/DropdownTileSF.dart';

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

  filter( int categoryId ){
    this.setState( (){

      if( categoryId == -1 ) {
        widget.cache.filterCategory = null;
        widget.cache.filterCategoryId = null;
        widget.cache.filterGroupId = null;
        widget.cache.showMyDay = true;
        widget.cache.filterGroup = false;

      } else if ( categoryId == -2 ) {
        widget.cache.filterCategory = null;
        widget.cache.filterCategoryId = null;
        widget.cache.filterGroupId = null;
        widget.cache.showMyDay = false;
        widget.cache.filterGroup = false;

      } else {

        widget.cache.filterCategoryId = categoryId;
        widget.cache.filterGroupId = null;
        widget.cache.filterCategory =
            widget.cache.categoryData.getCategoryGroup( categoryId ).text +
                ' / ' +
            widget.cache.categoryData.getCategory( categoryId ).text;

        widget.cache.showMyDay = false;
        widget.cache.filterGroup = false;
      }

    });

    Navigator.pop( context );
  }

  filterGroup( int groupId ){

    this.setState( (){

      widget.cache.filterCategoryId = null;
      widget.cache.filterGroupId = groupId;
      widget.cache.filterCategory = widget.cache.categoryData.getGroup( groupId ).text;

      widget.cache.showMyDay = false;
      widget.cache.filterGroup = true;

    });

    Navigator.pop( context );
  }

  @override
  Widget build(BuildContext context) {

    widget.cache.initNotifications(context);

    int categoryId = widget.cache.filterCategoryId;
    String categoryTxt = widget.cache.filterCategory;

    CategoryData categoryData = widget.cache.categoryData;

    int groupId = widget.cache.filterGroupId == null ?
                      ( categoryId == null ? null : categoryData.getCategoryGroup(categoryId).id ) :
                      widget.cache.filterGroupId;

    String groupTxt = widget.cache.filterGroupId == null ? null : categoryData.getGroup(groupId).text;

    AppBar appBar = new CTAppBar(

            filterCategoryId: categoryId,
            filterCategory: categoryTxt,

            groupId: groupId,
            groupName: groupTxt,

            deleteCategory: ((category) =>
                this.setState( (){
                  widget.cache.deleteCategory(category);
                  widget.cache.filterCategory = null;
                  widget.cache.filterCategoryId = null;
                  widget.cache.filterGroupId = null;
                  widget.cache.filterGroup = false;
                })
            ),

            deleteCategoryGroup: ((categoryGroup) =>
                this.setState( (){
                  widget.cache.deleteCategoryGroup(categoryGroup);
                  widget.cache.filterCategory = null;
                  widget.cache.filterCategoryId = null;
                  widget.cache.filterGroupId = null;
                  widget.cache.filterGroup = false;
                })
            ),

            isMyDay: widget.cache.showMyDay,
            isSearch: widget.cache.enableSearch,
            isGroup: widget.cache.filterGroup,

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
            updateColor: ( (value) {
                this.setState(() {
                  widget.settings.theme = value;
                });

                runApp(
                  new CleanToDoApp(
                    cache: widget.cache,
                    settings: widget.settings,
                  ),
                );
              }
            ),

            isShowCompletedTasks: widget.cache.showCompletedTasks,
            updateShowCompletedTasks: ((value) {

              widget.cache.showCompletedTasks = value;
              widget.cache.updateShowCompletedTasks()
                  .then( (_) {
                      this.setState(() {
                        widget.cache.showCompletedTasks = value;
                        widget.settings.showCompleted = value;
                      });

                  });
            }),

            updateSortTasks: ((value) =>
                this.setState((){
                  widget.cache.sortTasks = value;
                  widget.settings.sortString = value;
                })
            ),

            sortString: widget.cache.sortTasks,
            categoryName: widget.cache.filterCategoryId == null ? null : widget.cache.categoryData.getCategory( widget.cache.filterCategoryId ).text,

            updateCategoryName: ((newValue) =>
                this.setState((){
                  widget.cache.updateCategoryName(newValue);

                  widget.cache.filterCategory =
                      widget.cache.categoryData.getCategoryGroup( categoryId ).text +
                      ' / ' +
                      widget.cache.categoryData.getCategory( categoryId ).text;
                })
            ),

            updateGroupName: ((newValue) =>
                this.setState((){
                  widget.cache.updateGroupName( groupId, newValue );
                  groupTxt = newValue;
                  widget.cache.filterCategory = newValue;
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
            addCategoryGroup : ((newGroup) =>
                this.setState( (){
                  widget.cache.addCategoryGroup(newGroup);
                })
            ),

            filter : filter,
            filterGroup: filterGroup,
            userData : widget.cache.userData,

            cache: widget.cache,
            settings: widget.settings,

    );

    Widget myDayAppBody = new MyDayTasksList(

            todayTasks: widget.cache.todayTasks,
            dueTasks: widget.cache.dueTasks,
            pendingTasks: widget.cache.pendingTasks,
            extraTask: widget.cache.newTask,
            categoryData: widget.cache.categoryData,
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
        categoryData: widget.cache.categoryData,

        toggleTask: ( (task){
          this.setState( (){
            widget.cache.toggleTask(task);
          });
        }),

        updateTask: ( (task){
          this.setState( (){
            widget.cache.updateTask(task);
          });
        }),

        deleteTask: widget.cache.deleteTask,
    );

    Widget appBody = widget.cache.showMyDay ? myDayAppBody : listAppBody ;

    AppIcons icons = new AppIcons();
    FloatingActionButton appFabFilter = new FloatingActionButton(

            child: icons.newTaskFabIcon(context),
            //backgroundColor: Theme.of(context).primaryColor,

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
                                leading: icons.newTaskModal(context),
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
                                        widget.cache.newTask.id = widget.cache.tasksData.length == 0 ? 1 : widget.cache.tasksData.last.id + 1;
                                        widget.cache.newTask.title = value;
                                        widget.cache.newTask.category = widget.cache.categoryData.getCategory( widget.cache.filterCategoryId );
                                        widget.cache.addTask(widget.cache.newTask);
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                ),
                                trailing: new IconButton(
                                    icon: icons.newTaskModalArrow(context),
                                    onPressed: (){

                                      if( tecNewTask.text != null && tecNewTask.text.length > 0 ) {
                                        this.setState(() {
                                          widget.cache.newTask.clear();
                                          widget.cache.newTask.id = widget.cache.tasksData.length == 0 ? 1 : widget.cache.tasksData.last.id + 1;
                                          widget.cache.newTask.title = tecNewTask.text;
                                          widget.cache.newTask.category = widget.cache.categoryData.getCategory( widget.cache.filterCategoryId );
                                          widget.cache.addTask(widget.cache.newTask);
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

    FloatingActionButton appFabGroup = new FloatingActionButton(

        child: icons.newTaskFabIcon(context),

        onPressed: (){

          widget.cache.newTask.clear();
          TextEditingController tecNewTask = new TextEditingController();
          showModalBottomSheet<void>(

            context: context,
            builder: (BuildContext bcontext){

              return new _SystemPadding(
                  child: new Column(

                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        new ListTile(
                          dense: true,
                          title: new Text( "Add a to-do",
                            style: new TextStyle(color: Theme.of(context).accentColor.withAlpha(170)), ),
                        ),

                        new ListTile(
                          dense: true,
                          leading: icons.newTaskModal(context),
                          title: new TextField(
                            autofocus: true,
                            controller: tecNewTask,
                            decoration: new InputDecoration(
                              hintText: 'title',
                              hintStyle: new TextStyle( color: Colors.grey ),
                              border: InputBorder.none,
                            ),
                          ),
                          trailing: new IconButton(
                              icon: icons.newTaskModalArrow(context),
                              onPressed: (){

                                if( widget.cache.newTask.category == null ){
                                  
                                } else if( tecNewTask.text != null && tecNewTask.text.length > 0 ) {
                                  this.setState(() {
                                    widget.cache.newTask.id = widget.cache.tasksData.length == 0 ? 1 : widget.cache.tasksData.last.id + 1;
                                    widget.cache.newTask.title = tecNewTask.text;
                                    widget.cache.addTask(widget.cache.newTask);
                                    Navigator.pop(context);
                                  });
                                }
                              }
                          ),
                        ),

                        new DropdownTileSF(
                            icon: Icons.list,
                            text: widget.cache.newTask.category == null ? null : widget.cache.newTask.category.id.toString(),
                            hint: 'Select a List',
                            options: widget.cache.filterGroupId == null ?

                                widget.cache.categoryData.user.map((Category pCategory) {

                                  CategoryGroup categoryGroup =
                                      widget.cache.categoryData.getCategoryGroup( pCategory.id );

                                  return new DropdownMenuItem<String>(
                                    value: pCategory.id.toString(),
                                    child: new Text(categoryGroup.text + " / " + pCategory.text),
                                  );

                                }).toList()
                              :
                                widget.cache.categoryData.getGroupMembers(
                                    widget.cache.categoryData.getGroup( widget.cache.filterGroupId )
                                ).map((Category pCategory) {

                                  return new DropdownMenuItem<String>(
                                    value: pCategory.id.toString(),
                                    child: new Text(pCategory.text),
                                  );

                                }).toList(),
                            updateContent: (content) {
                              this.setState(() {
                                if (content == null)
                                  widget.cache.newTask.category = null;
                                else
                                  widget.cache.newTask.category = widget.cache.categoryData.getCategory( int.parse( content ) );
                              });
                            },

                        ),

                      ],
                    ),

              );
            },
          );

        }

    );

    FloatingActionButton appFabGeneric = new FloatingActionButton(

        child: icons.newTaskFabIcon(context),
        //backgroundColor: Theme.of(context).primaryColor,

        onPressed: (){

          widget.cache.newTask.clear();
          widget.cache.newTask.id = widget.cache.tasksData.length == 0 ? 1 : widget.cache.tasksData.last.id + 1;

          Navigator.push(
              context,
              new MaterialPageRoute( builder: (context) =>
                  new TaskDetail(
                    task: widget.cache.newTask,
                    categoryData: widget.cache.categoryData,
                    updateTask: (task){
                      widget.cache.addTask(task);
                    },
                  )
              )
          );

        }

    );

    FloatingActionButton appFab = widget.cache.showMyDay ? null :
          ( ( widget.cache.filterCategory == null ) || widget.cache.filterGroup ? appFabGroup : appFabFilter );

    return new Scaffold(
      appBar: appBar,
      drawer: appSidebar,
      body: appBody,
      floatingActionButton: appFab,
    );
  }
}