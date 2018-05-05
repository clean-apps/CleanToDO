import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/lists/TaskTile.dart';
import 'package:clean_todo/beans/Category.dart';

class TasksList extends StatefulWidget {

  TasksList({ this.tasks, this.extraTask, this.categories, this.toggleTask, this.updateTask, this.deleteTask });

  List<Task> tasks ;
  final Task extraTask ;
  final List<Category> categories ;

  final ValueChanged<Task> toggleTask;
  final ValueChanged<Task> updateTask ;
  final ValueChanged<Task> deleteTask ;

  @override
  _TasksListState createState() => new _TasksListState();

}

class _TasksListState extends State<TasksList> {

  @override
  Widget build(BuildContext context) {

      List<Widget> taskRowsList = [];
      widget.tasks.forEach(  (task){

          taskRowsList.add(

            new TaskTile (  
              task : task,
              extraTask: widget.extraTask,
              categories: widget.categories,
              updateTask : (task) => widget.updateTask(task),
              deleteTask: (task) => widget.deleteTask(task),
            ),

          );

          taskRowsList.add( new Divider( ) ); //color : Theme.of(context).primaryColor ) );
      });

      return new ListView(
          children: taskRowsList,
      );
    }
}