import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TaskDetail.dart';

class TaskTile extends StatefulWidget {

  TaskTile({ this.task , this.toggleTask });
  final Task task ;
  ValueChanged<Task> toggleTask;

  @override
  _TasksTileState createState() => new _TasksTileState();
}

class _TasksTileState extends State<TaskTile> {

  Widget getStatusIcon( bool completed ){

    return completed ?
              new CircleAvatar( child: new Icon( Icons.check, color: Colors.white, size: 14.0, ), 
                                backgroundColor: Theme.of(context).accentColor,
                                radius: 12.0, ) :
              new Icon( Icons.radio_button_unchecked, size: 28.0, color: Theme.of(context).accentColor, );

  }

  List<Widget> getSubtitleWidgets( Task task ){

    List<Widget> subtitleWidgets = [];

    Color primaryColor = Theme.of(context).primaryColor;

    double size = 14.0;
    EdgeInsets tmargin = new EdgeInsets.only( top: 10.0, );
    EdgeInsets lmargin = new EdgeInsets.only( left: 10.0, top: 10.0, );
    
    final TextStyle taskSubTitle = new TextStyle( color: primaryColor, fontWeight: FontWeight.w500 );

    if( task.category != null ) {

      subtitleWidgets.add(  
        new Padding(
          padding: tmargin,
          child: new Row(
            children: <Widget>[
              //new Icon( Icons.list, color: accentColor, size: size, ),
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
              new Icon( Icons.calendar_today, color: primaryColor, size: size, ),
              new Text( task.deadline, style: taskSubTitle  ),
            ],
          )
        )
      );

    }

    if( task.reminder != null ){
      subtitleWidgets.add(  
        new Padding(
            padding: lmargin,
            child: new Icon( Icons.alarm_on, color: primaryColor, size: size,  ) 
        )
      );
    }

    if( task.notes != null ){
      subtitleWidgets.add(  
        new Padding(
          padding: lmargin,
          child : new Icon( Icons.chat_bubble_outline, color: primaryColor, size: size, ),
        )
      );
    }

    return subtitleWidgets;
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle taskTitle = new TextStyle( fontWeight: FontWeight.normal );
    final TextStyle taskTitleChecked = new TextStyle( fontWeight: FontWeight.normal, decoration: TextDecoration.lineThrough );



    return new ListTile(

        leading: new IconButton(
            icon:  getStatusIcon( widget.task.completed ),
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
          Navigator.push(
            context, 
            new MaterialPageRoute( builder: (context) => new TaskDetail( task: widget.task ) )
          );

        },

      );
  }

}