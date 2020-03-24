import 'package:flutter/material.dart';

final Color trueText = Color(0xff004879);

Widget drawerView(bool isDark,Function setTheme){
  return ListView(
    children: <Widget>[
      DrawerHeader(
        child: Center(child: Text("Settings",style: TextStyle(fontSize: 32.0,color: isDark? Colors.white:trueText),)),
      ),
      ListTile(
        title: Text("Dark Mode"),
        trailing: Switch(
          value: isDark,
          onChanged: (value){
            setTheme(value);
          },
        ),
      )
    ],
  );
}