import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/ListBloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Color trueText = Color(0xff004879);
final Color trueBack = Color(0xffE0F2FE);
final trueBtn = Color(0xff42b3ff);
final Color floatingBTn = Color(0xff9ccff1);

Widget drawerView(
    {bool isDark,
    Function setTheme,
    Bloc bloc,
    int minAttendence,
    Function setMinAttendence,
    TextEditingController popupInput}) {
  _launchURL() async {
    const url = 'https://www.instagram.com/vishva_photography1/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> setMinAttendenceinDisk(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.setInt("minAttendence", value);
    return res;
  }

  Future<bool> setThemeData(bool local) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.setBool("theme", local);
    return res;
  }

  return Builder(
    builder: (context) => ListView(
      children: <Widget>[
        DrawerHeader(
          child: Center(
              child: SvgPicture.asset("Assets/settingsDark.svg",
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()))),
        ),
        ListTile(
          title: Text(
            "Dark Mode",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          ),
          trailing: Switch(
            value: isDark,
            onChanged: (value) async {
              setTheme(value);
              await setThemeData(value);
            },
          ),
        ),
        ListTile(
          onTap: () {
            showDialog(
                context: (context),
                child: AlertDialog(
                  title: Text(
                    "Min Attendence",
                    style: TextStyle(color: isDark ? Colors.white : trueText),
                  ),
                  actions: <Widget>[
                    OutlineButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: isDark ? trueBack : trueText,
                      ),
                      label: Text("Cancel",
                          style: TextStyle(
                              color: isDark ? trueBack : trueText,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400)),
                    ),
                    FlatButton.icon(
                        color: isDark ? trueBack : trueText,
                        onPressed: () async {
                          if (popupInput.text.isNotEmpty &&
                              int.parse(popupInput.text) < 100) {
                            setMinAttendence(int.parse(popupInput.text));
                            await setMinAttendenceinDisk(
                                int.parse(popupInput.text));
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.done,
                          color: isDark ? trueText : Colors.white,
                        ),
                        label: Text(
                          "Done",
                          style: TextStyle(
                              color: isDark ? trueText : Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                  content: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        controller: popupInput,
                        style: TextStyle(fontSize: 24.0),
                        keyboardType: TextInputType.numberWithOptions(),
                        onSubmitted: (value) async {
                          if (value.isNotEmpty && int.parse(value) < 100) {
                            setMinAttendence(int.parse(popupInput.text));
                            await setMinAttendence(int.parse(popupInput.text));
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty && int.parse(value) < 100) {
                            setMinAttendence(int.parse(popupInput.text));
                          }
                        },
                      ),
                    ),
                  ),
                ));
          },
          title: Text(
            "Attendence",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          ),
          trailing: Text(
            "$minAttendence %",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : trueText),
          ),
        ),
        ListTile(
          title: Text(
            "Delete All",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                  context: (context),
                  child: AlertDialog(
                      title: Text(
                        "Delete All",
                        style: TextStyle(
                            fontSize: 24.0,
                            color: isDark ? Colors.white : trueText),
                      ),
                      content: Text("This is permanent and cannot be undone"),
                      elevation: 12.0,
                      actions: <Widget>[
                        OutlineButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: isDark ? trueBack : trueText,
                          ),
                          label: Text("Cancel",
                              style: TextStyle(
                                  color: isDark ? trueBack : trueText,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400)),
                        ),
                        FlatButton.icon(
                            color: isDark ? trueBack : trueText,
                            onPressed: () {
                              bloc.deletAll();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: isDark ? trueText : Colors.white,
                            ),
                            label: Text(
                              "Delete",
                              style: TextStyle(
                                  color: isDark ? trueText : Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            )),
                      ]));
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 28.0,
            ),
          ),
        ),

        ListTile(
          title: Text(
            "Write a review",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            onPressed: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=vishva.of.messager.bunker';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            icon: Icon(
              Icons.rate_review_outlined,
              color: isDark ? Colors.white : trueText,
            ),
          ),
        ),

        ListTile(
          title: Text(
            "Share",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            onPressed: () async {
              try {
                Share.share(
                    "https://play.google.com/store/apps/details?id=vishva.of.messager.bunker",
                    subject: "Attendance Tracker");
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(
              Icons.share,
              color: isDark ? Colors.white : trueText,
            ),
          ),
        ),
      ],
    ),
  );
}
