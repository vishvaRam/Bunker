import 'package:flutter/material.dart';
import '../Model/Data.dart';
import './DataBase.dart';

final db = DBHelper.instance;

class ListModel extends ChangeNotifier{
  List<Data> list = List<Data>();

  void insert(String subject)async{
    await db.insert(subject);
  }

  void query(List<Data> result) async{
    list = result;
    notifyListeners();
  }

}