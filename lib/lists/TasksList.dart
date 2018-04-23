import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/lists/TaskTile.dart';

class TasksList extends StatefulWidget {

  TasksList({ this.tasks, this.toggleTask, this.updateTask, this.deleteTask });
  List<Task> tasks ;
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
              updateTask : (task){
                              widget.updateTask(task);
                            },
              deleteTask: (task){
                widget.deleteTask(task);
              },
            ),
          );

          taskRowsList.add( new Divider( ) ); //color : Theme.of(context).primaryColor ) );
      });

      return new ListView(
          children: taskRowsList,
      );
    }
}