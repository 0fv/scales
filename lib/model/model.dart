import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DBModel {
  Future<Database> _db;
  factory DBModel() => _sharedInstance();
  static DBModel _instance;

  Future<Database> initDB() async {
    if (_db == null) {
      _db = openDatabase(
        join(await getDatabasesPath(), 'wl_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE if not exists  wl_log(id INTEGER PRIMARY KEY, weight FLOAT, createdDate DATETIME,source VARCHAR(20))",
          );
        },
        version: 1,
      );
    }

    return _db;
  }

  DBModel._() {}

  Future<Database> db() {
    while (_db == null) {}
    return _db;
  }

  static DBModel _sharedInstance() {
    if (_instance == null) {
      _instance = DBModel._();
    }
    return _instance;
  }
}
