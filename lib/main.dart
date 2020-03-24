import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Provider/DataBase.dart';
import './Model/Data.dart';
import './Provider/ListBloc.dart';
import './Widgets/Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}


final Color trueBack =Color(0xffE0F2FE);
final Color trueText = Color(0xff004879);
final trueBtn = Color(0xff42b3ff);

final Color falseBack = Color(0xffFFF2E7);
final Color falseBtn = Color(0xffff5e7a);
final Color falseText = Color(0xff810016);
final Color floatingBTn = Color(0xff9ccff1);

class _MainState extends State<Main> {

  final Bloc bloc = Bloc();
  final db = DBHelper.instance;
  var textController = TextEditingController();
  bool isDark= false;


  setTheme(value){
    setState(() {
      isDark = value;
    });
  }

  @override
  void initState() {
    print(isDark);
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bunker",
      theme: ThemeData(
          brightness: isDark? Brightness.dark:Brightness.light
      ),
      home: SafeArea(
        child: Builder(
          builder: (context) => Scaffold(
            drawer: Drawer(
              child: drawerView(isDark,setTheme),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: floatingBTn,
              onPressed: () {
                showbottomSheet(context,textController);
              },
              child: Icon(Icons.add,color: trueText,),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              title: Text("Bunker",style: TextStyle(fontSize: 24.0,color: trueText),),
              actions: <Widget>[
                Builder(
                  builder:(context)=> IconButton(
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(Icons.settings,color: trueText,),
                  ),
                )
              ],
            ),
            body: Builder(
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<List<Data>>(
                  stream: bloc.listOUT,
                  builder:
                      (BuildContext context, AsyncSnapshot<List<Data>> snap) {
                    if (!snap.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snap.data.length ==0){
                      return Center(child: Text("Empty"),);
                    }
                    return ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (BuildContext context, i) {
                        return buildCards(snap, i);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildCards(AsyncSnapshot snap, int i) {
    int roundedPercentage =0;
    if(snap.data[i].totalClasses != 0){
      double percentage = ((snap.data[i].attended/snap.data[i].totalClasses)*100);
      roundedPercentage = percentage.round();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color:roundedPercentage < 75? falseBack:trueBack,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        height: 120.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Subject & button
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 15.0),
                    child: Text(
                      snap.data[i].subject,
                      style: TextStyle(fontSize: 30.0,color:roundedPercentage<75?falseText: trueText),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 15.0, bottom: 8, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          color: roundedPercentage<75 ? falseBtn: trueBtn,
                          onPressed: ()  {
                            bloc.attendedChange(snap.data[i]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "Attend",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          color:roundedPercentage<75 ? falseBtn: trueBtn,
                          onPressed: () {
                            bloc.bunkChange(snap.data[i]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "Bunk",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Percentage
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: roundedPercentage == 100 ? EdgeInsets.only(
                  left: 0.0, bottom: 0.0, top: 10.0):EdgeInsets.only(
                        left: 20.0, bottom: 0.0, top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          snap.data[i].totalClasses ==0? "0": roundedPercentage.toString(),
                          style: TextStyle(fontSize: 65.0,color: roundedPercentage<75?falseText: trueText),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "%",
                            style: TextStyle(fontSize: 26.0,color: roundedPercentage<75?falseText: trueText),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "attended : ${snap.data[i].attended}/${snap.data[i].totalClasses} ",
                      style: TextStyle(color: trueText),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showbottomSheet(context,TextEditingController _textController) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedPadding(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius:
                  BorderRadius.only(topRight: Radius.circular(30)),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Subject",
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: TextField(
                        controller: _textController,
                        style: TextStyle(fontSize: 18.0),
                        decoration:
                        InputDecoration(hintText: "Type the subject"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 20.0, left: 20.0, right: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: FlatButton(
                            onPressed: () async {
                              if (_textController.text != "") {
                                Navigator.pop(context);
                                bloc.addSubject(_textController.text);
                                _textController.clear();
                              }
                            },
                            color: trueBtn,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

}
