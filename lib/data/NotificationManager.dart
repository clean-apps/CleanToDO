import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/initialization_settings.dart';
import 'package:flutter_local_notifications/notification_details.dart';
import 'package:flutter_local_notifications/platform_specifics/android/initialization_settings_android.dart';
import 'package:flutter_local_notifications/platform_specifics/android/notification_details_android.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/initialization_settings_ios.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/notification_details_ios.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:clean_todo/lists/TasksPage.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/calender/TimeUtil.dart';
import 'dart:typed_data';
import 'package:clean_todo/data/NotificationProvider.dart';
import 'package:clean_todo/beans/Notification.dart';
import 'package:clean_todo/calender/DateUtil.dart';

enum CTRepeatInterval { NONE, DAILY, WEEKLY, WEEKDAYS, WEEKENDS, MONTHLY }

class NotificationManager {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;
  BuildContext context;

  NotificationProvider notificationProvider = new NotificationProvider();

  init( context ) {

    // initialise the plugin
    InitializationSettingsAndroid initializationSettingsAndroid = new InitializationSettingsAndroid('notification');
    InitializationSettingsIOS initializationSettingsIOS = new InitializationSettingsIOS();
    InitializationSettings initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, selectNotification: onSelectNotification);

    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    NotificationDetailsAndroid androidPlatformChannelSpecifics =
            new NotificationDetailsAndroid(
                'com.babanomania.cleantodo',
                'Task Reminders',
                'reminders to keep you motivated for the tasks',
                icon: 'notification',
                sound: 'slow_spring_board',
                vibrationPattern: vibrationPattern
            );

    NotificationDetailsIOS iOSPlatformChannelSpecifics =
            new NotificationDetailsIOS();

    platformChannelSpecifics =
            new NotificationDetails(
                androidPlatformChannelSpecifics,
                iOSPlatformChannelSpecifics
            );
  }

  Future onSelectNotification(String payload) async {
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new TasksPage() ),
    );
  }

  addReminder( Task task ) async {

    DateTime targetDateTime = _getTargetDate(task);
    if( targetDateTime == null ){
      return;
    }


    bool isTargetFuture = targetDateTime.isAfter( DateUtil.today );

    DateTime deadline = task.deadline_val == null ? null : DateTime.parse( task.deadline_val );


    if( task.repeat == CTRepeatInterval.NONE.index ) {

      if (isTargetFuture) {

        int newId = await _newId();
        await notificationProvider.insert( new NotificationData( id: newId, taskId: task.id ) );
        await flutterLocalNotificationsPlugin.schedule(
            newId,
            task.title,
            'Incomplete Task Reminder',
            targetDateTime,
            platformChannelSpecifics
        );
      }

    } else if ( deadline == null ){
      //this is absurd
      return ;

    } else if( task.repeat == CTRepeatInterval.DAILY.index ){

      int newId = await _newId();
      await notificationProvider.insert( new NotificationData( id: newId, taskId: task.id ) );

      await flutterLocalNotificationsPlugin.periodicallyShowTill(
          newId,
          task.title,
          'Incomplete Task Reminder',
          isTargetFuture ? targetDateTime : DateUtil.today,
          deadline,
          RepeatInterval.Daily,
          platformChannelSpecifics
      );

    } else if( task.repeat == CTRepeatInterval.WEEKLY.index ){

      int newId = await _newId();
      await notificationProvider.insert( new NotificationData( id: newId, taskId: task.id ) );

      await flutterLocalNotificationsPlugin.periodicallyShowTill(
          newId,
          task.title,
          'Incomplete Task Reminder',
          isTargetFuture ? targetDateTime : DateUtil.today,
          deadline,
          RepeatInterval.Weekly,
          platformChannelSpecifics
      );

    } else if( task.repeat == CTRepeatInterval.WEEKDAYS.index ){

      List<DateTime> days = _getWeekdays( isTargetFuture ? targetDateTime : DateUtil.today, deadline );
      int newId = await _newId();

      days.asMap().forEach( (i, targetDT) async {

        int newerId = newId + i;
        await notificationProvider.insert( new NotificationData( id: newerId, taskId: task.id ) );

        await flutterLocalNotificationsPlugin.periodicallyShowTill(
            newerId,
            task.title,
            'Incomplete Task Reminder',
            targetDT,
            deadline,
            RepeatInterval.Weekly,
            platformChannelSpecifics
        );

      });

    } else if( task.repeat == CTRepeatInterval.WEEKENDS.index ){

      List<DateTime> days = _getWeekends( isTargetFuture ? targetDateTime : DateUtil.today, deadline );
      int newId = await _newId();

      days.asMap().forEach( (i, targetDT) async {

        int newerId = newId + i;
        await notificationProvider.insert( new NotificationData( id: newerId, taskId: task.id ) );

        await flutterLocalNotificationsPlugin.periodicallyShowTill(
            newerId,
            task.title,
            'Incomplete Task Reminder',
            targetDT,
            deadline,
            RepeatInterval.Weekly,
            platformChannelSpecifics
        );

      });

    } else if( task.repeat == CTRepeatInterval.MONTHLY.index ){

      List<DateTime> days = _getMonthDays( targetDateTime, deadline );
      int newId = await _newId();

      days.asMap().forEach( (i, targetDT)async {

        int newerId = newId + i;
        await notificationProvider.insert( new NotificationData( id: newerId, taskId: task.id ) );

        await flutterLocalNotificationsPlugin.schedule(
            newerId,
            task.title,
            'Incomplete Task Reminder',
            targetDT,
            platformChannelSpecifics
        );

      });

    }

  }

  DateTime _getTargetDate( Task task ){

    if( task.reminder_date != null && task.reminder_time != null ) {

      DateTime targetDate = DateTime.parse(task.reminder_date);
      TimeOfDay targetTime = TimeUtil.parse_back(task.reminder_time);

      return targetDate
              .add(new Duration(hours: targetTime.hour))
              .add(new Duration(minutes: targetTime.minute));

    } else {
      return null;
    }

  }

  Future<bool> cancelReminder( Task task ) async {

    List<NotificationData> notifications = await notificationProvider.getNotificationsForTask( task.id );
    notifications.forEach( (notification) async {

      await flutterLocalNotificationsPlugin.cancel( task.id );
      await notificationProvider.delete( notification );

    });

    return true;
  }

  updateReminder( Task task ) async {
    await cancelReminder( task );
    await addReminder( task );
  }

  Future<int> _newId() async {
    int maxId = await notificationProvider.getMaxId();
    return maxId + 1;
  }

  List<DateTime> _getWeekdays( DateTime start, DateTime end ){

    List<DateTime> calculated = [];

    for( int i = 0; i < 7 ; i++ ){

      DateTime newDT2 = start.add( new Duration( days: i ) );
      if( newDT2.weekday != 6 && newDT2.weekday != 7 ){
        calculated.add( newDT2 );
      }

    }

    return calculated;

  }

  List<DateTime> _getWeekends( DateTime start, DateTime end ){

    List<DateTime> calculated = [];

    for( int i = 0; i < 7 ; i++ ){

      DateTime newDT2 = start.add( new Duration( days: i ) );
      if( newDT2.weekday == 6 || newDT2.weekday == 7 ){
        calculated.add( newDT2 );
      }

    }

    return calculated;

  }

  List<DateTime> _getMonthDays( DateTime start, DateTime end ){

    List<DateTime> calculated = [];

    var idx = 0;

    DateTime newDT = new DateTime( start.year, start.month, start.day, start.hour, start.minute );
    while( newDT.isBefore( end ) || !newDT.isAtSameMomentAs( end ) ){

      DateTime newDT2 = new DateTime( newDT.year, newDT.month + idx, newDT.day, newDT.hour, newDT.minute );
      calculated.add( newDT2 );
      idx += 1;
    }

    return calculated;

  }

}