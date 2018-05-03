import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/TextTaskDetailTile.dart';
import 'package:clean_todo/detail/DropdownTile.dart';
import 'package:clean_todo/detail/TitleDetailTile.dart';
import 'package:clean_todo/calender/DateUtil.dart';
import 'package:clean_todo/calender/TimeUtil.dart';
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
  final List<String> _reminders = ['Later Today @ 0900', 'Later Today @ 2100', 'Tomorrow @ 0900', 'Next Week @ 0900'];

  String getValueForCustom( deadline ){
    if( deadline == null ){
      return 'Custom';

    } else if ( _deadlines.contains(deadline) ) {
      return 'Custom';

    } else {
      return  deadline;

    }
  }

  String getTitleForCustom( deadlineVal ){
    if( deadlineVal == null ){
      return 'Custom';

    } else if ( _deadlines.contains(deadlineVal) ) {
      return 'Custom';

    } else {
      return  deadlineVal;

    }
  }

  String getReminderValueForCustom( reminder ){
    if( reminder == null ){
      return 'Custom';

    } else if ( _reminders.contains(reminder) ) {
      return 'Custom';

    } else {
      return  reminder;

    }
  }

  String getReminderTitleForCustom( reminderVal ){
    if( reminderVal == null ){
      return 'Custom';

    } else if ( _reminders.contains(reminderVal) ) {
      return 'Custom';

    } else {
      return  reminderVal;

    }
  }

  _update_deadline(content){

    if( !_deadlines.contains(content) && content != null ){

          Future<DateTime> picked = showDatePicker(
          context: context,
          firstDate: DateUtil.today,
          initialDate: content == 'Custom' ? DateUtil.today : DateTime.parse( widget.task.deadline_val ),
          lastDate: new DateTime.now().add( new Duration( days: 365 ) ),
        );
        
        picked.then( (pickedValue){
            if ( pickedValue != null )
            this.setState( (){
              widget.task.deadline_val = DateUtil.parse(pickedValue);
            });
        });

      } else {

        this.setState( (){
          widget.task.deadline_val = DateUtil.parse_string(content);
        });

      }
  }

   _update_reminder(String content) {

     if (!_reminders.contains(content) && content != null) {
       Future<DateTime> pickedDate = showDatePicker(
         context: context,
         firstDate: DateUtil.today,
         initialDate: content == 'Custom' ? DateUtil.today : DateTime.parse(widget.task.reminder_date),
         lastDate: new DateTime.now().add(new Duration(days: 365)),
       );

       pickedDate.then((pickedDateValue) {

         Future<TimeOfDay> pickedTime = showTimePicker(
           context: context,
           initialTime: content == 'Custom' ? TimeUtil.now : TimeUtil.parse_back(
               widget.task.reminder_time),
         );

         pickedTime.then((pickedTimeValue) {
           if (pickedDateValue != null && pickedTimeValue != null)
             this.setState(() {
               widget.task.reminder_date = DateUtil.parse(pickedDateValue);
               widget.task.reminder_time = TimeUtil.parse(pickedTimeValue);
             });
         });

       });

     } else if (content != null) {
       this.setState(() {
         List<String> date_time = content.split('@');
         widget.task.reminder_date = DateUtil.parse_string( date_time[0].trim() );
         widget.task.reminder_time = date_time[1].trim();
       });
     } else {
       this.setState(() {
         widget.task.reminder_date = null;
         widget.task.reminder_time = null;
       });
     }
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

                  new TitleDetailTile(

                        title: widget.task.title,
                        update_title: ((content){
                          this.setState((){
                            widget.task.title = content;
                          });
                        }),

                        completed: widget.task.completed,
                        update_completed: ((content){
                          this.setState((){
                            widget.task.completed = content;
                          });
                        }),

                  ),

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
                children: <Widget>[

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
                    text: widget.task.reminder,
                    hint: 'Remind Me',
                    icon: Icons.alarm_on,
                    options: <DropdownMenuItem<String>>[
                      new DropdownMenuItem<String>( value: 'Later Today @ ' + TimeUtil.reminder_time_val, child: new Text( 'Later Today @' + TimeUtil.reminder_time ), ),
                      new DropdownMenuItem<String>( value: 'Tomorrow @ 0900', child: new Text( 'Tomorrow @9' ), ),
                      new DropdownMenuItem<String>( value: 'Next Week @ 0900', child: new Text( 'Next Week @9' ), ),
                      new DropdownMenuItem<String>( value: getReminderValueForCustom(widget.task.reminder),
                        child: new Text( getReminderTitleForCustom(widget.task.reminder)  ), ),
                    ],

                    updateContent: _update_reminder,
                  ),

                ],
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