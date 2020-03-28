import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Provider/DataBase.dart';
import './Provider/ListBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './PeriodicAttendence.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

final Color trueBack = Color(0xffE0F2FE);
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
  var popupInput = TextEditingController();
  bool isDark = false;
  int minAttendence = 75;

  setMinAttendence(int value){
    print("setting ");
    setState(() {
      minAttendence = value;
    });
  }

  setTheme(value) {
    setState(() {
      isDark = value;
    });
  }

  Future<int> getMinAttendence() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt("minAttendence");
    return res;
  }
  getMinAttendenceFromDisk() async{
    var res = await getMinAttendence();
    setState(() {
      minAttendence = res ?? 75;
    });
  }

  Future<bool> getThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool("theme");
    print(res);
    return res;
  }

  getTheme() async {
    var res = await getThemeData();
    setState(() {
      isDark = res ?? false;
    });
  }

  // Initi
  @override
  void initState() {
    print(isDark);
    getMinAttendenceFromDisk();
    print(minAttendence);
    getTheme();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    popupInput.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bunker",
      theme: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      home: Periodic(bloc: bloc,isDark: isDark,minAttendence: minAttendence,popupInput: popupInput,setMinAttendence: setMinAttendence,setTheme: setTheme,textController: textController,),
    );
  }

}
