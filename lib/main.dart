import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './Provider/Provider.dart';
import './Provider/DataBase.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (_)=>ListModel(),
      child: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = DBHelper.instance;

  @override
  void initState() {
    super.initState();
    get();
  }
  get() async{
    try{
      var result = await db.queryAll();
      var appState = Provider.of<ListModel>(context,listen: false);
      appState.query(result);
    }catch(e){print(e);}
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ListModel>(context);
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
          body:Container(
            height:600.0,
            child: ListView.builder(
                itemCount: appState.list.length,
                itemBuilder: (context,i){
                  return ListTile(
                    title: Text(appState.list[i].subject),
                      subtitle: Text(appState.list[i].id.toString()),
                  );
                }
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: ()async{
              appState.insert("hi");
              appState.query(await db.queryAll());
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
