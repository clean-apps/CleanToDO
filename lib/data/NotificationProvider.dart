import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:clean_todo/beans/Notification.dart';

class NotificationProvider {


  static final String table = "notifications";
  static final String columnId = "_id";
  static final String columnTaskId = "taskId";

  Database _db;

  Future<Database> get db async {

    if(_db != null)
      return _db;

    _db = await initDb();
    return _db;

  }

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CleanToDoNotifications.db");
    await documentsDirectory.create(recursive: true);

    var theDb = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $table ( 
              $columnId integer primary key autoincrement, 
              $columnTaskId integer
            )
            ''');
        }
    );

    return theDb;
  }

  Future<List<NotificationData>> allNotifications() async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnTaskId]
    );

    List<NotificationData> allNotifications = [];
    maps.forEach(
            (mapItem) => allNotifications.add( NotificationData.fromMap(mapItem) )
    );

    return allNotifications;
  }

  insert(NotificationData notification) async {

    var dbClient = await db;
    await dbClient.insert(table, notification.toMap());
  }

  delete(NotificationData notification) async {

    var dbClient = await db;
    await dbClient.delete(
        table,
        where: "$columnId = ?",
        whereArgs: [notification.id]
    );
  }

  delete_all() async {

    var dbClient = await db;
    await dbClient.delete( table,  where: "1", );
  }

  Future<int> getMaxId() async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId],
        orderBy: columnId + " DESC",
        limit: 1
    );

    return ( maps == null || maps.length == 0 )?
            0 : maps.first[columnId];

  }

  Future<NotificationData> getNotification(int id) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnTaskId],
        where: "$columnId = ?",
        whereArgs: [id]
    );

    if (maps.length > 0) {
      return new NotificationData.fromMap(maps.first);
    }

    return null;
  }

  Future<List<NotificationData>> getNotificationsForTask( int taskId ) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnTaskId],
        where: "$columnTaskId = ?",
        whereArgs: [taskId]
    );

    List<NotificationData> notifications = [];
    if (maps.length > 0) {
      maps.forEach(
              (entry) => notifications.add(  new NotificationData.fromMap(entry) )
      );

    }

    return notifications;
  }


}