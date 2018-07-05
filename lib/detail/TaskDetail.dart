import 'package:flutter/material.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/detail/NoteDetailTile.dart';
import 'package:clean_todo/detail/DropdownTile.dart';
import 'package:clean_todo/detail/TitleDetailTile.dart';
import 'package:clean_todo/calender/DateUtil.dart';
import 'package:clean_todo/calender/TimeUtil.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'dart:async';
import 'package:clean_todo/data/NotificationManager.dart';
import 'dart:io';

class TaskDetail extends StatefulWidget {

  TaskDetail({ this.task, this.updateTask, this.categoryData, this.exitApp = false });

  final Task task ;
  final ValueChanged<Task> updateTask ;
  final CategoryData categoryData ;
  final bool exitApp ;

  _TaskDetailState createState() => new _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  final List<String> _deadlines = ['Today', 'Tomorrow', 'Next Week'];
  final List<String> _reminders = ['Later Today @ 09:00', 'Later Today @ 21:00', 'Tomorrow @ 09:00', 'Next Week @ 09:00'];

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
           initialTime: content == 'Custom' ? TimeUtil.now : TimeUtil.parse_back(widget.task.reminder_time),
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

  _update_repeat(content){

    if( content == null ) {
      this.setState(() {
        widget.task.repeat = null;
      });

    } else {
      this.setState(() {
        widget.task.repeat = int.parse(content);
      });

    }

  }

  _update_note(String content) {

    this.setState( (){
      widget.task.notes = content;
    });

  }

  @override
  Widget build(BuildContext context) {

    BuildContext scaffoldContext;

    return new Scaffold(

      appBar: new AppBar(
        title: widget.task.title == null ?
                    new Text( 'Create New Task' ) :
                    new Text( 'Update Task' ),
      ),

      body: new Builder(builder: (BuildContext bodyContext) {

          scaffoldContext = bodyContext;
          return new Column(

            children: <Widget>[

              new Card(
                child: new Column(
                  children: <Widget>[

                    new TitleDetailTile(

                      title: widget.task.title,
                      update_title: ((content) {
                        this.setState(() {
                          widget.task.title = content;
                        });
                      }),

                      completed: widget.task.completed,
                      update_completed: ((content) {
                        this.setState(() {
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

                      text: widget.task.category == null ? null : widget.task.category.id.toString(),
                      hint: 'Add to a List',
                      icon: Icons.list,
                      options: widget.categoryData.user.map((Category pCategory) {

                        Category category = widget.categoryData.getCategory( pCategory.id );
                        CategoryGroup categoryGroup = widget.categoryData.getCategoryGroup( pCategory.id );

                        return new DropdownMenuItem<String>(
                          value: pCategory.id.toString(),
                          child: new Text(categoryGroup.text + " / " + category.text ),
                        );

                      }).toList(),

                      updateContent: (content) {
                        this.setState(() {
                          if (content == null)
                            widget.task.category = null;
                          else
                            widget.task.category = widget.categoryData.getCategory( int.parse( content ) );
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
                      text: _deadlines.contains(widget.task.deadline) ? widget
                          .task.deadline : widget.task.deadline_val,
                      hint: 'Add Due Date',
                      icon: Icons.calendar_today,

                      options: <DropdownMenuItem<String>>[
                        new DropdownMenuItem<String>(
                          value: 'Today', child: new Text('Today'),),
                        new DropdownMenuItem<String>(
                          value: 'Tomorrow', child: new Text('Tomorrow'),),
                        new DropdownMenuItem<String>(
                          value: 'Next Week', child: new Text('Next Week'),),
                        new DropdownMenuItem<String>(
                          value: getValueForCustom(widget.task.deadline_val),
                          child: new Text(
                              getTitleForCustom(widget.task.deadline)),),
                      ],

                      updateContent: _update_deadline,
                    ),

                    new Divider(),

                    new DropdownTile(
                      text: widget.task.reminder,
                      hint: 'Remind Me',
                      icon: Icons.alarm_on,
                      options: <DropdownMenuItem<String>>[

                        new DropdownMenuItem<String>(
                          value: 'Later Today @ ' + TimeUtil.reminder_time_val,
                          child: new Text('Later Today @' + TimeUtil.reminder_time),),

                        new DropdownMenuItem<String>(
                          value: 'Tomorrow @ 09:00',
                          child: new Text('Tomorrow @9'),),

                        new DropdownMenuItem<String>(
                          value: 'Next Week @ 09:00',
                          child: new Text('Next Week @9'),),

                        new DropdownMenuItem<String>(
                          value: getReminderValueForCustom(widget.task.reminder),
                          child: new Text(getReminderTitleForCustom(widget.task.reminder)),),

                      ],

                      updateContent: _update_reminder,
                    ),

                    widget.task.reminder_date == null ? new Container() : new Divider(),

                    widget.task.reminder_date == null ? new Container() : new DropdownTile(

                      text: ( widget.task.repeat == null || widget.task.repeat == CTRepeatInterval.NONE.index ) ?
                              null :
                              widget.task.repeat.toString(),

                      hint: 'Repeat',
                      icon: Icons.repeat,
                      options: <DropdownMenuItem<String>>[

                        new DropdownMenuItem<String>(
                          value: CTRepeatInterval.DAILY.index.toString(),
                          child: new Text('daily'),
                        ),

                        new DropdownMenuItem<String>(
                          value: CTRepeatInterval.WEEKLY.index.toString(),
                          child: new Text('weekly'),
                        ),

                        new DropdownMenuItem<String>(
                          value: CTRepeatInterval.WEEKDAYS.index.toString(),
                          child: new Text('weekdays'),
                        ),

                        new DropdownMenuItem<String>(
                          value: CTRepeatInterval.WEEKENDS.index.toString(),
                          child: new Text('weekends'),
                        ),

                        new DropdownMenuItem<String>(
                          value: CTRepeatInterval.MONTHLY.index.toString(),
                          child: new Text('monthly'),
                        ),

                      ],

                      updateContent: _update_repeat,
                    ),

                  ],
                ),
              ),

              new Card(
                  child: new Padding(
                    padding: new EdgeInsets.only(bottom: 40.0),

                    child: new NoteDetailTile(
                      title: widget.task.title,
                      text: widget.task.notes,
                      hint: 'Add a note',
                      icon: Icons.chat_bubble_outline,
                      updateContent: _update_note,

                    ),

                  )
              ),

            ],

          );

        },

      ),

      floatingActionButton: new FloatingActionButton(

          child: new Icon(Icons.save),
          onPressed: (){

            if( widget.exitApp ){
              exit(0);

            } else if( widget.task.title == null ){
              final snackBar = new SnackBar(content: new Text('please enter a title'), backgroundColor: Colors.red,);
              Scaffold.of(scaffoldContext).showSnackBar(snackBar);

            } else if ( widget.task.category == null ){
              final snackBar = new SnackBar(content: new Text('please select a list'), backgroundColor: Colors.red,);
              Scaffold.of(scaffoldContext).showSnackBar(snackBar);

            } else {
              widget.updateTask(widget.task);
              Navigator.pop(context);
            }
          },

      ),
      
    );
  }

}