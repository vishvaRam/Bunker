import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/PeriodicAttendence.dart';
import 'Pages/Intro.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bunker",
      home: Theme(
          data: ThemeData(
              brightness: isDark ? Brightness.dark : Brightness.light),
          child: Builder(
              builder: (context) => Intro(isDark))),
//              builder: (context) => Periodic(isDark: isDark,))),
    );
  }
}
