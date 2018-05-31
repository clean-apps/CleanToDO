import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';


class CategoryGroupProvider {

  static final String table = "categoryGroup";
  static final String columnId = "_id";
  static final String columnText = "text";

  Database _db;

  Future<Database> get db async {

    if(_db != null)
      return _db;

    _db = await initDb();
    return _db;

  }

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CleanToDoCategoryGroup.db");
    await documentsDirectory.create(recursive: true);

    var theDb = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
            await db.execute('''
            create table $table ( 
              $columnId integer primary key autoincrement, 
              $columnText text not null
            )
            ''');
        }
    );

    return theDb;
  }

  insertAll(List<CategoryGroup> categoryGroups) {
    categoryGroups.forEach( (categoryGroup) => insert( categoryGroup.clone() ) );
  }

  insert(CategoryGroup categoryGroup) async {

    var dbClient = await db;
    await dbClient.insert(table, categoryGroup.toMap());
  }

  Future<CategoryGroup> getCategoryGroup(int id) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnText],
        where: "$columnId = ?",
        whereArgs: [id]
    );

    if (maps.length > 0) {
      return new CategoryGroup.fromMap(maps.first);
    }

    return null;
  }

  Future<List<CategoryGroup>> allCategoryGroups() async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnText]
    );

    List<CategoryGroup> allCategoryGroups = [];
    maps.forEach(
            (mapItem) => allCategoryGroups.add( CategoryGroup.fromMap(mapItem) )
    );

    return allCategoryGroups;
  }

  Future<CategoryGroup> getCategoryByText(String text) async {

    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        table,
        columns: [columnId, columnText],
        where: "$columnText = ?",
        whereArgs: [text]
    );

    if (maps.length > 0) {
      return new CategoryGroup.fromMap(maps.first);
    }

    return null;
}

  delete(int id) async {
    var dbClient = await db;
    await dbClient.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  update(CategoryGroup categoryGroup) async {
    var dbClient = await db;
    await dbClient.update(
            table,
            categoryGroup.toMap(),
            where: "$columnId = ?", whereArgs: [categoryGroup.id]
    );
  }

  Future close() async => _db.close();
}