import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? db;

class DatabaseCreator {
  static const moneyexchangeTable = 'moneyexchange';

  static const id = 'id';
  static const data = 'data';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>>? selectQueryResult,
        int? insertAndUpdateQueryResult,
        List<dynamic>? params]) {
   // print(functionName);
   // print(sql);
   // if (params != null) {
   //   print(params);
   // }
   // if (selectQueryResult != null) {
   //   print(selectQueryResult);
   // } else if (insertAndUpdateQueryResult != null) {
   //   print(insertAndUpdateQueryResult);
   // }
  }

  Future<void> createDownloadTable(Database db) async {
    final tblDownload = '''CREATE TABLE $moneyexchangeTable
    (
      $id INTEGER,
      $data TEXT
    )''';

    await db.execute(tblDownload);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('moneyexchange');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createDownloadTable(db);
    print(db.isOpen);
  }
}
