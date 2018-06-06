import 'package:clean_todo/data/NotificationProvider.dart';

class NotificationData {

  NotificationData({ this.id, this.taskId });

  int id;
  int taskId;

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      NotificationProvider.columnId: id,
      NotificationProvider.columnTaskId: taskId,
    };

    return map;
  }

  NotificationData.fromMap( Map map ) {

    id = map[NotificationProvider.columnId];
    taskId = map[NotificationProvider.columnTaskId];
  }
}