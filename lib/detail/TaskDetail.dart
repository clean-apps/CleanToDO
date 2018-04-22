import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TaskDetailTile.dart';
import 'package:clean_todo/detail/DummyInputDialog.dart';

class TaskDetail extends StatefulWidget {

  TaskDetail({ this.task, this.updateTask });
  final Task task ;
  final ValueChanged<Task> updateTask ;

  _TaskDetailState createState() => new _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

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
        title: widget.task.category == null ? new Text( 'To-Do' ) : new Text( widget.task.category.text ),
      ),

      body: new Column(

        children: <Widget>[

            new Card(
              child: new Column(

                
                children: <Widget>[

                  new ListTile(

                    leading: new IconButton(
                        icon:  getStatusIcon( widget.task.completed, context ),
                        onPressed: (){
                          
                          this.setState((){
                            widget.task.completed ? widget.task.completed = false : widget.task.completed = true ;
                            widget.updateTask( widget.task );
                          });

                        },
                    ),

                    title: new Padding(

                      padding: new EdgeInsets.only( top : 20.0, bottom: 20.0 ),
                      child: new Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          new Text( 'Title', style: new TextStyle( fontSize: 12.0, color: Colors.grey ), ),
                          widget.task.title == null ? 
                                              new Text( 'untitled', style: new TextStyle( fontSize: 24.0, color: Colors.grey ), ) :
                                              new Text( widget.task.title, style: new TextStyle( fontSize: 24.0, ) ),

                        ],

                      ) ,
                    ),

                    onTap: (){
                      showDialog(
                        context: context,
                        child: new DummyInputDialog(
                          title: 'Title',
                          content: widget.task.title,
                          updateContent: (content){
                            this.setState( (){
                              widget.task.title = content;
                              widget.updateTask( widget.task );
                            });
                          },
                        ),
                      );
                    }, 
                  )

                ],
              ),
            ),

            new Card(
              child: new Column(

                children: <Widget>[

                  new TaskDetailTile(
                    text: widget.task.deadline,
                    hint: 'Add Due Date',
                    icon: Icons.calendar_today,
                    updateContent: (content){
                      this.setState( (){
                        widget.task.deadline = content;
                        widget.updateTask( widget.task );
                      });
                    },
                  ),

                  new Divider(),

                  new TaskDetailTile(
                    text: widget.task.reminder,
                    hint: 'Remind Me',
                    icon: Icons.alarm_on,
                    updateContent: (content){
                      this.setState( (){
                        widget.task.reminder = content;
                        widget.updateTask( widget.task );
                      });
                    },
                  ),

                ],

              ),
            ),

            new Card(
              child: new Padding(
                padding: new EdgeInsets.only(bottom: 40.0),
                child: new TaskDetailTile(
                    text: widget.task.notes,
                    hint: 'Add a note',
                    icon: Icons.chat_bubble_outline,
                    updateContent: (content){
                      this.setState( (){
                        widget.task.notes = content;
                        widget.updateTask( widget.task );
                      });
                    },
                  ),
              )
              
            ),

        ],

      )
      
    );
  }

}