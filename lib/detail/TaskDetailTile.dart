import 'package:flutter/material.dart';

class TaskDetailTile extends StatefulWidget{
  TaskDetailTile({ this.text, this.hint, this.icon });

  final String text ;
  final String hint ;
  final IconData icon ;

  @override
  _TaskDetailTileState createState() => new _TaskDetailTileState();
}

class _TaskDetailTileState extends State<TaskDetailTile>{

  @override
    Widget build(BuildContext context) {
      return new ListTile(

          leading: new Icon( widget.icon, color: Theme.of(context).primaryColor, size: 28.0 ,),

          title: widget.text == null ? 
                  new Text( widget.hint, style: new TextStyle( color: Colors.grey ), ) :
                  new Text( widget.text, style: new TextStyle( color: Theme.of(context).primaryColor ), ),

          trailing: widget.text == null ? null : new Icon( Icons.clear, color: Theme.of(context).primaryColor, ),

        );
    }

}