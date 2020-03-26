import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Color trueText = Color(0xff004879);

Widget drawerView(bool isDark,Function setTheme){

  Future<bool> setThemeData(bool local)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.setBool("theme", local);
    return res;
  }

  return ListView(
    children: <Widget>[
      DrawerHeader(
        child: Center(child: Text("Settings",style: TextStyle(fontSize: 32.0,color: isDark? Colors.white:trueText),)),
      ),
      ListTile(
        title: Text("Dark Mode"),
        trailing: Switch(
          value: isDark,
          onChanged: (value) async{
            setTheme(value);
            await setThemeData(value);
          },
        ),
      )
    ],
  );
}