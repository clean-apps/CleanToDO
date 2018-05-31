import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/lists/TaskTile.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/lists/CTExpansionPanel.dart';
import 'package:clean_todo/beans/CategoryData.dart';

class MyDayTasksList extends StatefulWidget {

  MyDayTasksList({  this.todayTasks, this.dueTasks,  this.pendingTasks,
                    this.extraTask, this.categoryData, this.toggleTask,
                    this.updateTask, this.deleteTask });


  List<Task> todayTasks ;
  List<Task> dueTasks ;
  List<Task> pendingTasks ;

  final Task extraTask ;
  final CategoryData categoryData ;

  final ValueChanged<Task> toggleTask;
  final ValueChanged<Task> updateTask ;
  final ValueChanged<Task> deleteTask ;



  @override
  _MyDayTasksListState createState() => new _MyDayTasksListState();

}

class _MyDayTasksListState extends State<MyDayTasksList> {

  @override
  Widget build(BuildContext context) {

    List<Widget> todayTaskRowsList = [];
    widget.todayTasks.forEach(  (task){

      todayTaskRowsList.add(

        new TaskTile (
          task : task,
          extraTask: widget.extraTask,
          categoryData: widget.categoryData,
          updateTask : (task) => widget.updateTask(task),
          deleteTask: (task) => widget.deleteTask(task),
        ),

      );

      todayTaskRowsList.add( new Divider( ) ); //color : Theme.of(context).primaryColor ) );
    });

    if (todayTaskRowsList.length > 1 ) todayTaskRowsList.removeLast();

    List<Widget> dueTaskRowsList = [];
      widget.dueTasks.forEach(  (task){

          dueTaskRowsList.add(

            new TaskTile (  
              task : task,
              extraTask: widget.extraTask,
              categoryData: widget.categoryData,
              updateTask : (task) => widget.updateTask(task),
              deleteTask: (task) => widget.deleteTask(task),
            ),

          );

          dueTaskRowsList.add( new Divider( ) ); //color : Theme.of(context).primaryColor ) );
      });

      if (dueTaskRowsList.length > 1 ) dueTaskRowsList.removeLast();

      List<Widget> pendingTaskRowsList = [];
      widget.pendingTasks.forEach(  (task){

        pendingTaskRowsList.add(

          new TaskTile (
            task : task,
            extraTask: widget.extraTask,
            categoryData: widget.categoryData,
            updateTask : (task) => widget.updateTask(task),
            deleteTask: (task) => widget.deleteTask(task),
          ),

        );

        pendingTaskRowsList.add( new Divider( ) ); //color : Theme.of(context).primaryColor ) );
      });

      if (pendingTaskRowsList.length > 1 ) pendingTaskRowsList.removeLast();

      List<CTExpansionPanel> _items = [

        new CTExpansionPanel(

          label: 'Today',
          subtitle : widget.todayTasks.length == 1 ?  '1 Pending' : widget.todayTasks.length.toString() + ' Pending',
          body: new Column(
            children: todayTaskRowsList,
          ),
        ),

        new CTExpansionPanel(

          label: 'Overdue',
          subtitle : widget.dueTasks.length == 1 ?  '1 Pending' : widget.dueTasks.length.toString() + ' Pending',
          body: new Column(
            children: dueTaskRowsList,
          ),
        ),

        new CTExpansionPanel(

          label : 'Upcoming',
          subtitle: widget.pendingTasks.length == 1 ? '1 Task' : widget.pendingTasks.length.toString() + ' Tasks',
          body: new Column(
            children: pendingTaskRowsList,
          ),
        )

      ];

      return new Container(
        color: Theme.of(context).primaryColor,
        child: new ListView(
          children: _items. map( (panel){
            return panel.build(context);
          }).toList(),
        )
      ) ;
    }
}