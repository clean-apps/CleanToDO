import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TaskDetail.dart';
import 'package:clean_todo/lists/LeaveBehindView.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/data/NotificationManager.dart';
import 'package:clean_todo/styles/AppIcons.dart';

class TaskTile extends StatefulWidget {

  TaskTile({ this.task , this.extraTask, this.categoryData, this.toggleTask, this.updateTask, this.deleteTask });

  final Task task ;
  final Task extraTask ;

  final CategoryData categoryData ;
  final ValueChanged<Task> toggleTask;
  final ValueChanged<Task> updateTask ;
  final ValueChanged<Task> deleteTask ;

  @override
  _TasksTileState createState() => new _TasksTileState();
}

class _TasksTileState extends State<TaskTile> {

  final AppIcons icons = new AppIcons();

  List<Widget> getSubtitleWidgets( Task task ){

    List<Widget> subtitleWidgets = [];

    EdgeInsets tmargin = new EdgeInsets.only( top: 10.0, );
    EdgeInsets lmargin = new EdgeInsets.only( left: 10.0, top: 10.0, );

    final TextStyle taskSubTitle = new TextStyle( color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w500 );
    final TextStyle taskSubTitleDue = new TextStyle( color: Theme.of(context).errorColor, fontWeight: FontWeight.w500 );

    if( task.category != null ) {

      subtitleWidgets.add(  
        new Padding(
          padding: tmargin,
          child: new Row(
            children: <Widget>[
              new Text( task.category.text, style: taskSubTitle  ),
            ],
          )
        )
      );

    }

    if( task.deadline != null ){

      subtitleWidgets.add(  
        new Padding(
          padding: lmargin,
          child: new Row(
            children: <Widget>[
              icons.listIconDue( context, task.isDue ),
              new Text( task.isDue ? 'Due ' + task.deadline : task.deadline,
                        style: task.isDue ? taskSubTitleDue : taskSubTitle  ),
            ],
          )
        )
      );

    }

    if( task.reminder != null ){
      subtitleWidgets.add(  
        new Padding(
            padding: lmargin, child: icons.listIconReminder(context),
        )
      );
    }

    if( task.notes != null ){
      subtitleWidgets.add(  
        new Padding(
          padding: lmargin, child : icons.listIconNotes(context),
        )
      );
    }

    if( task.repeat != null && task.repeat != CTRepeatInterval.NONE.index){
      subtitleWidgets.add(
          new Padding(
              padding: lmargin, child: icons.listIconRepeat(context)
          )
      );
    }

    return subtitleWidgets;
  }

  Map<DismissDirection, double> _dismissThresholds() {
    Map<DismissDirection, double> map = new Map<DismissDirection, double>();
    map.putIfAbsent(DismissDirection.horizontal, () => 0.5);
    return map;
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle taskTitle = new TextStyle( fontWeight: FontWeight.normal );
    final TextStyle taskTitleChecked = new TextStyle( fontWeight: FontWeight.normal, decoration: TextDecoration.lineThrough );

    return new Dismissible(

      key: new Key( widget.task.id.toString() ),
      background: new LeaveBehindViewLeft(),
      secondaryBackground: new LeaveBehindViewRight(),
      direction: DismissDirection.horizontal,
      dismissThresholds: _dismissThresholds(),

      onDismissed: ((disDir) {
        widget.deleteTask(widget.task);

        final snackBar = new SnackBar( content: new Text("Task Deleted") );
        Scaffold.of(context).showSnackBar(snackBar);

      }),

      child: new ListTile(

        leading: new IconButton(

            icon:  widget.task.completed ? icons.taskCompletedIcon(context) : icons.taskPendingIcon(context),

            onPressed: (){

              this.setState((){
                widget.task.completed ? widget.task.completed = false : widget.task.completed = true ;
              });

              widget.toggleTask( widget.task );

            },
        ),

        title: new Text( widget.task.title, style : widget.task.completed ? taskTitleChecked : taskTitle ),

        subtitle: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: getSubtitleWidgets( widget.task ),
        ),

        onTap: (){

          widget.extraTask.copy(widget.task);

          Navigator.push(
            context, 
            new MaterialPageRoute( builder: (context) => 
                        new TaskDetail( 
                            task: widget.extraTask,
                            categoryData: widget.categoryData,
                            updateTask: (task){
                              widget.updateTask(task);
                            },
                        )
            )
          );

        },

      ),
    );
  }

}