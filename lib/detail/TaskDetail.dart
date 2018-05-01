import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TextTaskDetailTile.dart';
import 'package:clean_todo/detail/TextInputDialog.dart';
import 'package:clean_todo/detail/DropdownTile.dart';
import 'package:clean_todo/detail/CTDropdownMenuItem.dart';
import 'package:clean_todo/calender/DateToString.dart';
import 'package:clean_todo/calender/Dates.dart';
import 'package:clean_todo/beans/Category.dart';
import 'dart:async';

class TaskDetail extends StatefulWidget {

  TaskDetail({ this.task, this.updateTask, this.categories });

  final Task task ;
  final ValueChanged<Task> updateTask ;
  final List<Category> categories ;

  _TaskDetailState createState() => new _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  final List<String> _deadlines = ['Today', 'Tomorrow', 'Next Week'];
  final List<String> _reminders = ['Later Today', 'Tomorrow', 'Next Week'];

  Widget getStatusIcon( bool completed, context ){

    return completed ?
              new CircleAvatar( child: new Icon( Icons.check, color: Colors.white, size: 14.0, ), 
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 12.0, ) :
              new Icon( Icons.radio_button_unchecked, size: 28.0, color: Theme.of(context).primaryColor, );

  }

  String getValueForCustom( deadline ){
    if( deadline == null ){
      return 'Custom';

    } else if ( _deadlines.contains(deadline) ) {
      return 'Custom';

    } else {
      return  deadline;

    }
  }

  String getTitleForCustom( deadline_val ){
    if( deadline_val == null ){
      return 'Custom';

    } else if ( _deadlines.contains(deadline_val) ) {
      return 'Custom';

    } else {
      return  deadline_val;

    }
  }

  _update_deadline(content){

    if( !_deadlines.contains(content) && content != null ){

          Future<DateTime> picked = showDatePicker(
          context: context,
          firstDate: Dates.today,
          initialDate: content == 'Custom' ? Dates.today : DateTime.parse( widget.task.deadline_val ),
          lastDate: new DateTime.now().add( new Duration( days: 365 ) ),
        );
        
        picked.then( (pickedValue){
            if ( pickedValue != null )
            this.setState( (){
              widget.task.deadline_val = Dates.parse(pickedValue);
            });
        });

      } else {

        this.setState( (){
          widget.task.deadline_val = Dates.parse_string(content);
        });

      }
  }

   _update_reminder(content){

    if( !_reminders.contains(content) && content != null ){

        Future<DateTime> picked = showDatePicker(
          context: context,
          firstDate: Dates.today,
          initialDate: content == 'Custom' ? Dates.today : DateTime.parse( widget.task.deadline_val ),
          lastDate: new DateTime.now().add( new Duration( days: 365 ) ),
        );
        
        picked.then( (pickedValue){
            if ( pickedValue != null )
            this.setState( (){
              widget.task.deadline_val = Dates.parse(pickedValue);
            });
        });

      } else {

        this.setState( (){
          widget.task.deadline_val = Dates.parse_string(content);
        });

      }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> datesAndReminder = <Widget>[

        new DropdownTile(
          text: _deadlines.contains( widget.task.deadline ) ? widget.task.deadline : widget.task.deadline_val,
          hint: 'Add Due Date',
          icon: Icons.calendar_today,
          options: <DropdownMenuItem<String>>[
            new DropdownMenuItem<String>( value: 'Today', child: new Text( 'Today' ), ),
            new DropdownMenuItem<String>( value: 'Tomorrow', child: new Text( 'Tomorrow' ), ),
            new DropdownMenuItem<String>( value: 'Next Week', child: new Text( 'Next Week' ), ),
            new DropdownMenuItem<String>( value: getValueForCustom(widget.task.deadline_val), 
                                          child: new Text( getTitleForCustom(widget.task.deadline)  ), ),
          ],

          updateContent: _update_deadline,
        ),

        new Divider(),

        new DropdownTile(
          text: _reminders.contains( widget.task.reminder ) ? widget.task.reminder : widget.task.reminder_val,
          hint: 'Remind Me',
          icon: Icons.alarm_on,
          options: <DropdownMenuItem<String>>[
            new DropdownMenuItem<String>( value: 'Later Today', child: new Text( 'Later Today' ), ),
            new DropdownMenuItem<String>( value: 'Tomorrow', child: new Text( 'Tomorrow' ), ),
            new DropdownMenuItem<String>( value: 'Next Week', child: new Text( 'Next Week' ), ),
            new DropdownMenuItem<String>( value: getValueForCustom(widget.task.reminder_val), 
                                          child: new Text( getTitleForCustom(widget.task.reminder)  ), ),
          ],

          updateContent: _update_reminder,
        ),

        new TextTaskDetailTile(
          text: widget.task.reminder,
          hint: 'Remind Me',
          icon: Icons.alarm_on,
          updateContent: (content){
            this.setState( (){
              widget.task.reminder = content;
            });
          },
        ),

    ];

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
                        child: new TextInputDialog(
                          title: 'Title',
                          content: widget.task.title,
                          updateContent: (content){
                            this.setState( (){
                              widget.task.title = content;
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

                  new DropdownTile(
                    text: widget.task.category == null ? null : widget.task.category.text,
                    hint: 'Add to a List',
                    icon: Icons.list,
                    options: widget.categories.map( (Category pCategory){
                                            return new DropdownMenuItem<String>(
                                              value: pCategory.text,
                                              child: new Text(pCategory.text),
                                            );
                                        }).toList(),
                    updateContent: (content){
                      this.setState( (){
                        if( content == null ) widget.task.category = null ;
                        else widget.task.category = new Category(text: content);
                      });
                    },
                  ),

                ],

              ),
            ),

            new Card(
              child: new Column(
                children: datesAndReminder,
              ),
            ),

            new Card(
              child: new Padding(
                padding: new EdgeInsets.only(bottom: 40.0),
                child: new TextTaskDetailTile(
                    text: widget.task.notes,
                    hint: 'Add a note',
                    icon: Icons.chat_bubble_outline,
                    updateContent: (content){
                      this.setState( (){
                        widget.task.notes = content;
                      });
                    },
                  ),
              )
              
            ),

        ],

      ),

      floatingActionButton: new FloatingActionButton(
              child: new Icon(Icons.save),
              onPressed: (){
                widget.updateTask( widget.task ); 
                Navigator.pop(context);
              },
            ),
      
    );
  }

}