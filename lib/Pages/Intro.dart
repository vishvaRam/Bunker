import 'package:flutter/material.dart';
import 'PeriodicAttendence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Day.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    print("Selected");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstTime", true);
  }

  setPeriodic(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("periodic", value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("Assets/school.svg",
                  placeholderBuilder: (BuildContext context) => Container(
                      child: Center(child: const CircularProgressIndicator()))),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
              "Select the attendance type your school,\ncollage or University is using.",
              style: TextStyle(
                fontSize: 20,
                color: trueText,
              ),
              textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton(
                    height: 45.0,
                    minWidth: 120.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: trueText)),
                    onPressed: () {
                      showDialog(context: (context),child: AlertDialog(
                        backgroundColor: Colors.white,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 38,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                "Note",
                                style:
                                TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                        content: Text("You can change this any time in settings.",style: TextStyle(color: trueText),),
                        actions: [
                          OutlineButton.icon(

                            borderSide: BorderSide(
                                width: 1, color: trueText),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: trueText,
                            ),
                            label: Text("Cancel",
                                style: TextStyle(
                                    color: trueText,
                                    fontSize: 18.0,
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                          FlatButton.icon(
                              color: trueText,
                              onPressed: () {
                                setAppRunsFirstTime();
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
                                  color: trueBack),
                              label: Text(
                                "OK",
                                style: TextStyle(
                                    color: trueBack,
                                    fontSize: 18.0,
                                    fontWeight:
                                    FontWeight.w400),
                              )),
                        ],
                      ));
                    },
                    child: Text(
                      "Periodic",
                      style: TextStyle(color: trueText, fontSize: 22),
                    ),
                    color: Colors.white,
                  ),
                  FlatButton(
                    height: 45.0,
                    minWidth: 120.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: trueText)),
                    onPressed: () {
                      showDialog(context: (context),child: AlertDialog(
                        backgroundColor: Colors.white,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 38,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                "Note",
                                style:
                                TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                        content: Text("You can change this any time in settings.",style: TextStyle(color: trueText),),
                        actions: [
                          OutlineButton.icon(

                            borderSide: BorderSide(
                                width: 1, color: trueText),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: trueText,
                            ),
                            label: Text("Cancel",
                                style: TextStyle(
                                    color: trueText,
                                    fontSize: 18.0,
                                    fontWeight:
                                    FontWeight.w400)),
                          ),
                          FlatButton.icon(
                              color: trueText,
                              onPressed: () {
                                setAppRunsFirstTime();
                                setPeriodic(false);
                                Navigator.of(context).popUntil(
                                        (route) => route.isFirst);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>Day(widget.isDark)));
                              },
                              icon: Icon(Icons.done,
                                  color: trueBack),
                              label: Text(
                                "OK",
                                style: TextStyle(
                                    color: trueBack,
                                    fontSize: 18.0,
                                    fontWeight:
                                    FontWeight.w400),
                              )),
                        ],
                      ));
                    },
                    child: Text(
                      "Day",
                      style: TextStyle(color: trueText, fontSize: 22),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
