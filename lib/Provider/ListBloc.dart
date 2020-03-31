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
    if(result.length !=0){
      print(result[0].totalClasses);
    }
   blocList = result;
    _listController.add(blocList);
  }

  addSubject (String text)async{
    await db.insert(text);
    getData();
  }

  attendedChange(Data data) async {
   try{
     await db.attendedAndTotalClassesIncrement(data);
     for(int i =0; i<blocList.length;i++){
       while(blocList[i].subject == data.subject){
         blocList[i].totalClasses++;
         blocList[i].attended++;
         break;
       }
     }
     listIN.add(blocList);
   }catch(e){print(e);}
  }

  bunkChange(Data data) async {
     try{
       await db.bunkChanges(data);
       for(int i =0; i<blocList.length;i++){
         while(blocList[i].subject == data.subject){
           blocList[i].totalClasses++;
           break;
         }
       }
       listIN.add(blocList);
     }catch(e){print(e);}
  }

  // Edit Option
  editOption(Data data) async {
    try{
      await db.editOption(data);
      listIN.add(blocList);
    }catch(e){print(e);}
  }

  delete(int id) async{
    blocList.removeWhere((item)=> item.id == id);
    await db.delete(id);
  }

  deletAll() async{
    await db.deleteAll();
    getData();
  }

  void dispose() {
    _listController.close();
  }
}
