import 'package:flutter/material.dart';
import 'PeriodicAttendence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Day.dart';

// ignore: must_be_immutable
class Intro extends StatefulWidget {
  Intro(this.isDark);
  bool isDark;
  @override
  _IntroState createState() => _IntroState();
}

final Color trueBack = Color(0xffE0F2FE);
final Color trueText = Color(0xff004879);
final Color falseBtn = Color(0xffff5e7a);

class _IntroState extends State<Intro> {
  setAppRunsFirstTime() async {
    print("first Time");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstTime", true);
  }

  setPeriodic(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("periodic", value);
  }

  @override
  void initState() {
    setAppRunsFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Scaffold(
        body: Center(
            child: Container(
          height: 350.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          child: Material(
            elevation: 8.0,
            child: Container(
              color: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Attendance Tracker",
                        style: TextStyle(fontSize: 32.0, color: trueBack),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                      child: Text(
                          "Select the attendance type used in your school,college or Institute",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.warning,
                        size: 34.0,
                        color: falseBtn,
                      ),
                      title: Text(
                        "It cannot be changed after!",
                        style: TextStyle(color: falseBtn),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              height: 45.0,
                              child: FlatButton(
                                onPressed: () {
                                  showDialog(
                                      context: (context),
                                      child: AlertDialog(
                                        elevation: 12.0,
                                        title: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning,
                                              color: falseBtn,
                                              size: 38,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "WARNING",
                                                style:
                                                    TextStyle(color: falseBtn),
                                              ),
                                            )
                                          ],
                                        ),
                                        content: Text(
                                            "This change is permanent.You cannot change after!"),
                                        actions: <Widget>[
                                          OutlineButton.icon(
                                            borderSide: BorderSide(
                                                width: 1, color: trueBack),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: trueBack,
                                            ),
                                            label: Text("Cancel",
                                                style: TextStyle(
                                                    color: trueBack,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                          FlatButton.icon(
                                              color: trueBack,
                                              onPressed: () {
                                                setPeriodic(true);
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Periodic(
                                                              isDark: widget.isDark,
                                                            )));
                                              },
                                              icon: Icon(Icons.done,
                                                  color: trueText),
                                              label: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: trueText,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      ));
                                },
                                color: trueBack,
                                child: Text(
                                  "Periodic",
                                  style:
                                      TextStyle(color: trueText, fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              height: 45.0,
                              child: FlatButton(
                                onPressed: () {
                                  showDialog(
                                      context: (context),
                                      child: AlertDialog(
                                        elevation: 12.0,
                                        title: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning,
                                              color: falseBtn,
                                              size: 38,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "WARNING",
                                                style:
                                                    TextStyle(color: falseBtn),
                                              ),
                                            )
                                          ],
                                        ),
                                        content: Text(
                                            "This change is permanent.You cannot change after!"),
                                        actions: <Widget>[
                                          OutlineButton.icon(
                                            borderSide: BorderSide(
                                                width: 1, color: trueBack),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: trueBack,
                                            ),
                                            label: Text("Cancel",
                                                style: TextStyle(
                                                    color: trueBack,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                          FlatButton.icon(
                                              color: trueBack,
                                              onPressed: () {
                                                setPeriodic(false);
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Day(widget
                                                                .isDark)));
                                              },
                                              icon: Icon(Icons.done,
                                                  color: trueText),
                                              label: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: trueText,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      ));
                                },
                                color: trueBack,
                                child: Text(
                                  "Day",
                                  style:
                                      TextStyle(color: trueText, fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
