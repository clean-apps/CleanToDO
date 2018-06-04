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

enum RepeatInterval { DAILY, WEEKLY, WEEKDAYS, WEEKENDS, MONTHLY }

class NotificationManager {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;
  BuildContext context;

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

    if( task.reminder_date != null && task.reminder_time != null ) {

      DateTime targetDate = DateTime.parse(task.reminder_date);
      TimeOfDay targetTime = TimeUtil.parse_back(task.reminder_time);

      var scheduleDateTime = targetDate
          .add(new Duration(hours: targetTime.hour))
          .add(new Duration(minutes: targetTime.minute));

      await flutterLocalNotificationsPlugin.schedule(
          task.id,
          task.title,
          'Incomplete Task Reminder',
          scheduleDateTime,
          platformChannelSpecifics
      );

    }

  }

  cancelReminder( Task task ) async {
    await flutterLocalNotificationsPlugin.cancel( task.id );
  }

  updateReminder( Task task ) async {
    await cancelReminder( task );
    await addReminder( task );
  }

}