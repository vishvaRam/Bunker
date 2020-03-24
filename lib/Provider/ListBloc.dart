import 'dart:async';
import './DataBase.dart';
import '../Model/Data.dart';

class Bloc {
  final db = DBHelper.instance;

  List<Data> blocList = List<Data>();

  final _listController = StreamController<List<Data>>.broadcast();

  // OUT Stream for List
  Stream<List<Data>> get listOUT => _listController.stream;
  // IN Stream for List
  StreamSink<List<Data>> get listIN => _listController.sink;

  // constructor
  Bloc() {
    getData();
  }

  getData() async {
    var result = await db.queryAll();
   blocList = result;
    _listController.add(blocList);
  }

  addSubject (String text)async{
    await db.insert(text);
    getData();
  }

  attendedChange(Data data) async {
    await db.attendedAndTotalClassesIncrement(data);
    listIN.add(blocList);
  }

  bunkChange(Data data) async {
    await db.bunkChanges(data);
    listIN.add(blocList);
  }

  void dispose() {
    _listController.close();
  }
}
