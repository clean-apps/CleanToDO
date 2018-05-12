import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:clean_todo/beans/Category.dart';


class CategoryProvider {

  static final String table = "catagory";
  static final String columnId = "_id";
  static final String columnText = "text";
  static final String columnCount = "count";

  Database _db;

  Future<Database> get db async {

    if(_db != null)
      return _db;

    _db = await initDb();
    return _db;

  }

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CleanToDoCategories.db");
    await documentsDirectory.create(recursive: true);

    var theDb = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
            await db.execute('''
            create table $table ( 
              $columnId integer primary key autoincrement, 
              $columnText text not null,
              $columnCount integer not null
            )
            ''');
        }
    );

    return theDb;
  }

  insertAll(List<Category> categories) {
    categories.forEach( (category) => insert( category.clone() ) );
  }

  insert(Category category) async {

    var dbClient = await db;
    await dbClient.insert(table, category.toMap());
  }

  Future<Category> getCategory(int id) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnText, columnCount],
        where: "$columnId = ?",
        whereArgs: [id]
    );

    if (maps.length > 0) {
      return new Category.fromMap(maps.first);
    }

    return null;
  }

  Future<List<Category>> allCategories() async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnText, columnCount]
    );

    List<Category> allCategories = [];
    maps.forEach(
            (mapItem) => allCategories.add( Category.fromMap(mapItem) )
    );

    return allCategories;
  }

  Future<Category> getCategoryByText(String text) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnText, columnCount],
        where: "$columnText = ?",
        whereArgs: [text]
    );

    if (maps.length > 0) {
      return new Category.fromMap(maps.first);
    }

    return null;
}

  delete(int id) async {
    var dbClient = await db;
    await dbClient.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  update(Category category) async {
    var dbClient = await db;
    await dbClient.update(
            table,
            category.toMap(),
            where: "$columnId = ?", whereArgs: [category.id]
    );
  }

  Future close() async => _db.close();
}