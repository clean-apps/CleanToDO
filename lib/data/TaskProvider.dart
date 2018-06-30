import 'dart:async';
import 'package:clean_todo/beans/Task.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:clean_todo/beans/CategoryData.dart';

class TaskProvider {

  static final String table = "task";
  static final String columnId = "_id";
  static final String columnTitle = "title";
  static final String columnCompleted = "completed";
  static final String columnCategoryId = "categoryId";
  static final String columnDeadlineVal = "deadlineVal";
  static final String columnReminderDate = "reminderData";
  static final String columnReminderTime = "reminderTime";
  static final String columnRepeat = "repeat";
  static final String columnNotes = "notes";

  Database _db;

  Future<Database> get db async {

    if(_db != null)
      return _db;

    _db = await initDb();
    return _db;

  }

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "CleanToDoTasks.db");
    await documentsDirectory.create(recursive: true);

    var theDb = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $table ( 
              $columnId integer primary key autoincrement, 
              $columnTitle text not null,
              $columnCompleted integer not null,
              $columnCategoryId integer not null,
              $columnDeadlineVal text,
              $columnReminderDate text,
              $columnReminderTime text,
              $columnRepeat integer,
              $columnNotes text
            )
            ''');
        }
    );

    return theDb;
  }

  insert(Task task) async {

    var dbClient = await db;
    Map<String, dynamic> ohThatMap = task.toMap();
    await dbClient.insert(table, ohThatMap);

    return true;
  }

  Future<List<Task>> allTasksPending( CategoryData categoryData ) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnTitle, columnCompleted, columnCategoryId,
        columnDeadlineVal, columnReminderDate, columnReminderTime, columnRepeat, columnNotes],
        where: "$columnCompleted = ?",
        whereArgs: [0]
    );

    List<Task> allTasks = [];
    maps.forEach(
            (mapItem) => allTasks.add( Task.fromMap(mapItem, categoryData ) )
    );

    return allTasks;
  }

  Future<List<Task>> allTasks( CategoryData categoryData ) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnTitle, columnCompleted, columnCategoryId,
        columnDeadlineVal, columnReminderDate, columnReminderTime, columnRepeat, columnNotes]
    );

    List<Task> allTasks = [];
    maps.forEach(
            (mapItem) => allTasks.add( Task.fromMap(mapItem, categoryData ) )
    );

    return allTasks;
  }

  Future<Task> getTask(int id,  CategoryData categoryData ) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnTitle, columnCompleted, columnCategoryId,
                  columnDeadlineVal, columnReminderDate, columnReminderTime,
                  columnRepeat, columnNotes],
        where: "$columnId = ?",
        whereArgs: [id]
    );

    if (maps.length > 0) {
      return new Task.fromMap(maps.first, categoryData);
    }

    return null;
  }

  delete(int id) async {

    var dbClient = await db;
    await dbClient.delete(
            table,
            where: "$columnId = ?",
            whereArgs: [id]
    );
  }

  delete_all() async {

    var dbClient = await db;
    await dbClient.delete(table, where: "1");
  }

  update(Task task) async {

    var dbClient = await db;
    await dbClient.update(
            table,
            task.toMap(),
            where: "$columnId = ?",
            whereArgs: [task.id]
    );
  }

  Future close() async => _db.close();
}