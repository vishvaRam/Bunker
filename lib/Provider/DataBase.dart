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
      Map<String, dynamic> values = {
        "subject": text,
        "totalClasses": 0,
        "attended": 0
      };
      Database db = await instance.database;
      print("from insert "+db.toString());
      return await db.insert(DBName, values,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<List<Data>> queryAll() async {
    try{
      Database db = await instance.database;
      final List<Map<String,dynamic>> result = await db.query(DBName,orderBy: "id DESC");
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
    }catch(e){print(e);}

  }

  // In General
  Future<void> attendedAndTotalClassesIncrement(Data data) async{
    try{
      print(data.totalClasses.toString()+" and "+data.attended.toString());

      Database db = await instance.database;

      int newAttended = data.attended+1;
      int newTotalClasses = data.totalClasses+1;

      Map<String,dynamic> mapData ={
        "id":data.id,
        "subject":data.subject,
        "totalClasses":newTotalClasses,
        "attended":newAttended
      };
      var res = await db.update(
          DBName,
          mapData,
          where: "id = ?",
          whereArgs: [data.id]
      );

      print("in DB"+res.toString()+ mapData.toString());
    }
    catch(e){print(e);}
  }

  // Edit option
  Future<void> editOption(Data data) async{
    try{
      Database db = await instance.database;
      Map<String,dynamic> mapData ={
        "id":data.id,
        "subject":data.subject,
        "totalClasses":data.totalClasses,
        "attended":data.attended
      };
      var res = await db.update(
          DBName,
          mapData,
          where: "id = ?",
          whereArgs: [data.id]
      );

      print("in DB"+res.toString()+ mapData.toString());
    }
    catch(e){print(e);}
  }


  Future<void> bunkChanges(Data data) async{
    try{
      print(data.totalClasses.toString()+" and "+data.attended.toString());
      Database db = await instance.database;

      int newAttended = data.attended;
      int newTotalClasses = data.totalClasses+1;

      Map<String,dynamic> mapData ={
        "id":data.id,
        "subject":data.subject,
        "totalClasses":newTotalClasses,
        "attended":newAttended
      };
      var res = await db.update(
          DBName,
          mapData,
          where: "id = ?",
          whereArgs: [data.id]
      );
      print("form bunkChange"+res.toString()+" "+mapData.toString());
    }catch(e){print(e);}
  }

  Future<void> deleteAll() async{
    Database db = await instance.database;
    db.delete(DBName);
  }

  Future<void> delete(int id) async{
    Database db = await instance.database;
    await db.delete(DBName,where: "id=?",whereArgs: [id]);
  }

}
