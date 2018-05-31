import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/lists/TaskTile.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/CategoryData.dart';

class TasksList extends StatefulWidget {

  TasksList({ this.tasks, this.extraTask, this.categoryData, this.toggleTask, this.updateTask, this.deleteTask });

  final List<Task> tasks ;
  final Task extraTask ;
  final CategoryData categoryData ;

  final ValueChanged<Task> toggleTask;
  final ValueChanged<Task> updateTask ;
  final ValueChanged<Task> deleteTask ;

  @override
  _TasksListState createState() => new _TasksListState();

}

class _TasksListState extends State<TasksList> {

  @override
  Widget build(BuildContext context) {

      return new ListView(
          children: ListTile.divideTiles(
              tiles: widget.tasks.map(
                      (task) => new TaskTile (
                                  task : task,
                                  extraTask: widget.extraTask,
                                  categoryData: widget.categoryData,
                                  toggleTask: (task) => widget.toggleTask(task),
                                  updateTask : (task) => widget.updateTask(task),
                                  deleteTask: (task) => widget.deleteTask(task),
                                )

              ).toList(),
              color: Colors.grey,

          ).toList(),
      );
    }
}