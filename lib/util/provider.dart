import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    print("initDB");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quick_counter.db");
    const scripts = {};

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db){},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE users("
                  "id INTEGER PRIMARY KEY,"
                  "name TEXT,"
                  "number double,"
                  "large_az double,"
                  "small_az double"
                  ");"
          );
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          for (var i = oldVersion + 1; i <= newVersion; i++) {
            var queries = scripts[i.toString()];
            for (String query in queries) {
              await db.execute(query);
            }
          }
        }
    );
  }
}