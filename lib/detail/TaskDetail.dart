import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TaskDetailTile.dart';

class TaskDetail extends StatelessWidget {

  TaskDetail({ this.task });
  final Task task ;

  Widget getStatusIcon( bool completed, context ){

    return completed ?
              new CircleAvatar( child: new Icon( Icons.check, color: Colors.white, size: 14.0, ), 
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 12.0, ) :
              new Icon( Icons.radio_button_unchecked, size: 28.0, color: Theme.of(context).primaryColor, );

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(
        title: new Text( task.category.text ),
      ),

      body: new Column(

        children: <Widget>[

            new Card(
              child: new Column(

                
                children: <Widget>[

                  new ListTile(

                    leading: getStatusIcon( task.completed, context ),
                    title: new Padding(

                      padding: new EdgeInsets.only( top : 20.0, bottom: 20.0 ),
                      child: new Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          new Text( 'Title', style: new TextStyle( fontSize: 12.0, color: Colors.grey ), ),
                          new Text( task.title, style: new TextStyle( fontSize: 24.0, ) ),

                        ],

                      ) ,
                    ) 
                  )

                ],
              ),
            ),

            new Card(
              child: new Column(

                children: <Widget>[

                  new TaskDetailTile(
                    text: task.deadline,
                    hint: 'Add Due Date',
                    icon: Icons.calendar_today,
                  ),

                  new Divider(),

                  new TaskDetailTile(
                    text: task.reminder,
                    hint: 'Remind Me',
                    icon: Icons.alarm_on,
                  ),

                ],

              ),
            ),

            new Card(
              child: new Padding(
                padding: new EdgeInsets.only(bottom: 40.0),
                child: new TaskDetailTile(
                    text: task.notes,
                    hint: 'Add a note',
                    icon: Icons.chat_bubble_outline,
                  ),
              )
              
            ),

            new ButtonTheme.bar(
              child: new ButtonBar(
                children: <Widget>[

                  new FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  new FlatButton(
                    child: const Text('Save'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                ],
              ),
            ),

        ],

      )
      

    );
  }

}