import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/PeriodicAttendence.dart';
import 'Pages/Intro.dart';
import './Pages/Day.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  bool isDark = false;

  Future<bool> getAppRunsFirstTime() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool("isFirstTime");
    if(res == true){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> getType() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var res = prefs.getBool("periodic");
    if(res == true){
      return true;
    }else{
      return false;
    }
  }

  // Getting Theme
  Future<bool> getThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool("theme");
    print(res);
    return res;
  }

  // Applying Theme
  getTheme() async {
    var res = await getThemeData();
    print("get:"+res.toString());
    setState(() {
      isDark = res ?? false;
    });
  }

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Attendance Tracker",
      home: Theme(
          data: ThemeData(
              brightness: Brightness.dark),
          child: Builder(
              builder: (context) => FutureBuilder(
                  future: getAppRunsFirstTime(),
                  builder: (context,snapShot){
                    if(snapShot.hasData){
                      if(snapShot.data == true){
                        return FutureBuilder(
                          future: getType(),
                          builder: (context,snapShot){
                            if(snapShot.data == true){
                              return Periodic(isDark: isDark,);
                            }if(snapShot.data ==false){
                              return Day(isDark);
                            }
                            return Container();
                          },
                        );
                      }
                      else{
                        return Intro(true);
                      }
                    }
                    return Container();
                  },
              )
          )
      ),
    );
  }
}
