import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TaskDetailTile.dart';
import 'package:clean_todo/detail/DummyInputDialog.dart';
import 'package:clean_todo/beans/Category.dart';

class TaskAdd extends StatelessWidget {

  TaskAdd({ this.addTask });
  
  String title ;
  String category ;
  String deadline ;
  String reminder ;
  String notes ;
  bool completed = false ;

  final ValueChanged<Task> addTask ;

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
        title: new Text( 'To-Do' ),
      ),

      body: new Column(

        children: <Widget>[

            new Card(
              child: new Column(

                
                children: <Widget>[

                  new ListTile(

                    leading: new IconButton(
                        icon:  getStatusIcon( this.completed, context ),
                        onPressed: (){
                          this.completed ? this.completed = false : this.completed = true ;
                        },
                    ),

                    title: new Padding(

                      padding: new EdgeInsets.only( top : 20.0, bottom: 20.0 ),
                      child: new Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          new Text( 'Title', style: new TextStyle( fontSize: 12.0, color: Colors.grey ), ),
                          this.title == null ? 
                                              new Text( 'untitled', style: new TextStyle( fontSize: 24.0, color: Colors.grey ), ) :
                                              new Text( this.title, style: new TextStyle( fontSize: 24.0, ) ),

                        ],

                      ) ,
                    ),

                    onTap: (){
                      showDialog(
                        context: context,
                        child: new DummyInputDialog(
                          title: 'Title',
                          content: this.title,
                          updateContent: (content){
                              this.title = content;
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
                    text: this.category,
                    hint: 'Add a category',
                    icon: Icons.list,
                    updateContent: (content){
                      this.category = content;
                    },
                  ),

                ],

              ),
            ),

            new Card(
              child: new Column(

                children: <Widget>[

                  new TaskDetailTile(
                    text: this.deadline,
                    hint: 'Add Due Date',
                    icon: Icons.calendar_today,
                    updateContent: (content){
                        this.deadline = content;
                    },
                  ),

                  new Divider(),

                  new TaskDetailTile(
                    text: this.reminder,
                    hint: 'Remind Me',
                    icon: Icons.alarm_on,
                    updateContent: (content){
                        this.reminder = content;
                    },
                  ),

                ],

              ),
            ),

            new Card(
              child: new Padding(
                padding: new EdgeInsets.only(bottom: 40.0),
                child: new TaskDetailTile(
                    text: this.notes,
                    hint: 'Add a note',
                    icon: Icons.chat_bubble_outline,
                    updateContent: (content){
                        this.notes = content;
                    },
                  ),
              )
              
            ),
        ],

      ),

      floatingActionButton: new FloatingActionButton(
              child: new Icon(Icons.save),
              onPressed: () => this.addTask( 
                new Task( 
                  title: title,
                  reminder: reminder,
                  deadline: deadline,
                  notes: notes,
                  category: new Category( text: category )
                ) 
              )
            ),
      
    );
  }

}