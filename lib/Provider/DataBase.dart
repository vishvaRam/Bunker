import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/Data.dart';

class DBHelper {
  // ignore: non_constant_identifier_names
  String DBName = "Bunker";
  // ignore: non_constant_identifier_names
  int DBVersion = 1;
  String subject = "subject";
  String totalClasses = "totalClasses";
  String attended = "attended";

  // Singelton Class
  DBHelper._instance();

  static final DBHelper instance = DBHelper._instance();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      return _database = await _initialDatabase();
    }
  }

  _initialDatabase() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      var path = dir.path + DBName;
      return await openDatabase(path, version: DBVersion, onCreate: _onCreate);
    } catch (e) {
      print(e);
    }
  }

  _onCreate(Database db, int version) async {
    try {
      await db.execute("CREATE TABLE $DBName "
          "("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$subject TEXT,"
          "$totalClasses INTEGER,"
          "$attended INTEGER"
          ")");
      print("DB Created");
    } catch (e) {
      print(e);
    }
  }

  // Insert
  // ignore: missing_return
  Future<int> insert(String text) async {
    try {
      print("$text inserted");
      Map<String, dynamic> values = {
        "subject": text,
        "totalClasses": 0,
        "attended": 0
      };
      Database db = await instance.database;
      return await db.insert(DBName, values,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Data>> queryAll() async {
    Database db = await instance.database;

    final List<Map<String,dynamic>> result = await db.query(DBName);
    if(result.length != null){
      print("Queried");
      return List.generate(
          result.length,
              (i){
            return Data(
                id: result[i]['id'],
                subject: result[i]['subject'],
                totalClasses: result[i]['totalClasses'],
                attended: result[i]['attended']
            );
          }
      );
    }else{
      return null;
    }
  }
}
