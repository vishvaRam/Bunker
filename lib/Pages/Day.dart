import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/AlartDialogWidget.dart';

// ignore: must_be_immutable
class Day extends StatefulWidget {
  Day(this.isDark);
  bool isDark;
  @override
  _DayState createState() => _DayState();
}

final Color trueBack = Color(0xffE0F2FE);
final Color trueBackgreen = Color(0xffDEFFEC);
final Color trueText = Color(0xff004879);
final Color trueTextgrn = Color(0xff016322);
final trueBtn = Color(0xff00b549);

final Color falseBack = Color(0xffFFF2E7);
final Color falseBtn = Color(0xffff5e7a);
final Color falseText = Color(0xff810016);
final Color floatingBTn = Color(0xff9ccff1);

class _DayState extends State<Day> {
  int minAttendence = 75;
  int totalDays = 0;
  int attended = 0;
  var attendenceController = TextEditingController();

  _launchURL() async {
    const url = 'https://www.instagram.com/vishva_photography1/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //Setting Theme
  Future<bool> setThemeData(bool local) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.setBool("theme", local);
    print(res);
    return res;
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
    print("get:" + res.toString());
    setState(() {
      widget.isDark = res ?? false;
    });
  }

  // Setting int
  Future<bool> setMinAttendenceinDisk(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Setted :" + value.toString());
    var res = prefs.setInt("minAttendence", value);
    return res;
  }

  // Getting Min Attendence
  Future<int> getMinAttendence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt("minAttendence");
    return res;
  }

  //Setting Total Days
  Future<bool> setTotalDays(int local) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.setInt("totalDays", local);
    print(res);
    return res;
  }

  Future<int> getTotalDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt("totalDays");
    return res;
  }

  //Setting Total Days
  Future<bool> setAttended(int local) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.setInt("attended", local);
    print(res);
    return res;
  }

  Future<int> getAttended() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt("attended");
    return res;
  }

  // Applying int
  getAllVar() async {
    var res = await getMinAttendence();
    var totalDaysRes = await getTotalDays();
    var attendedRes = await getAttended();
    print("Min attendence: " + res.toString());
    print("Total Days: " + totalDays.toString());
    print("attended: " + attended.toString());
    setState(() {
      minAttendence = res ?? 75;
      totalDays = totalDaysRes ?? 0;
      attended = attendedRes ?? 0;
    });
  }

  @override
  void initState() {
    getTheme();
    getAllVar();
    super.initState();
  }

  @override
  void dispose() {
    attendenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int roundedPercentage = 0;
    if (totalDays != 0) {
      double percentage = ((attended / totalDays) * 100);
      roundedPercentage = percentage.round();
    }

    final TextStyle rusultedText = TextStyle(
        fontSize: 24.0,
        color: roundedPercentage < minAttendence ? falseText : trueTextgrn);

    return Theme(
      data: ThemeData(
          brightness: widget.isDark ? Brightness.dark : Brightness.light),
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(),
          drawer: buildDrawer(),
          body: Container(
            margin: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 50.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: roundedPercentage < minAttendence
                    ? falseBack
                    : trueBackgreen,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "$roundedPercentage",
                        style: TextStyle(
                            color: roundedPercentage < minAttendence
                                ? falseText
                                : trueTextgrn,
                            fontSize: roundedPercentage == 100 ? 150.0 : 180,
                            height: 1.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "%",
                          style: TextStyle(
                            fontSize: 100.0,
                            color: roundedPercentage < minAttendence
                                ? falseText
                                : trueTextgrn,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          " Attended : $attended/$totalDays",
                          style: rusultedText,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black54,
                          size: 30.0,
                        ),
                        onPressed: () {
                          showDialog(
                              context: (context),
                              child: AlartForDayEdit(
                                isDark: widget.isDark,
                                attended: attended,
                                totalClasses: totalDays,
                                setAttended: setAttended,
                                setTotalDays: setTotalDays,
                                getAllvar: getAllVar,
                              ));
                        },
                      )
                    ],
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: roundedPercentage < minAttendence
                                ? Colors.redAccent
                                : Colors.blue,
                            width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: warningWidget(roundedPercentage),
                    )),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Builder(
                    builder: (context) => Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                onPressed: () async {
                                  int newTotalDays = totalDays + 1;
                                  int newAttended = attended + 1;
                                  setState(() {
                                    totalDays = newTotalDays;
                                    attended = newAttended;
                                  });
                                  await setTotalDays(newTotalDays);
                                  await setAttended(newAttended);
                                },
                                color: roundedPercentage < minAttendence
                                    ? falseBtn
                                    : trueBtn,
                                child: Text(
                                  "ATTEND",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                onPressed: () async {
                                  int newTotalDays = totalDays + 1;
                                  setState(() {
                                    totalDays = newTotalDays;
                                  });
                                  await setTotalDays(newTotalDays);
                                },
                                color: roundedPercentage < minAttendence
                                    ? falseBtn
                                    : trueBtn,
                                child: Text(
                                  "BUNK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget warningWidget(int value) {
    if (value == 0) {
      return textWidget("Welcome to Class Bunker App", value);
    } else if (value < minAttendence) {
      return textWidget("You have to attend classes!", value);
    } else if (value == 100) {
      return textWidget(
          "Excelent ,You don't have to worry about your attendence", value);
    } else if (value > minAttendence) {
      return textWidget("Every thing is fine for now.", value);
    } else if (value == minAttendence) {
      return textWidget("You have to attend classes!", value);
    }
  }

  Text textWidget(String text, int value) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16.0, color: value < minAttendence ? falseText : trueText),
      textAlign: TextAlign.center,
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      elevation: 9.0,
      child: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 32.0,
                    color: widget.isDark ? Colors.white : trueText),
              )),
            ),
            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              trailing: Switch(
                value: widget.isDark,
                onChanged: (value) async {
                  await setThemeData(value);
                  setState(() {
                    widget.isDark = value;
                  });
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
                        style: TextStyle(
                            color: widget.isDark ? Colors.white : trueText),
                      ),
                      actions: <Widget>[
                        OutlineButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: widget.isDark ? trueBack : trueText,
                          ),
                          label: Text("Cancel",
                              style: TextStyle(
                                  color: widget.isDark ? trueBack : trueText,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400)),
                        ),
                        FlatButton.icon(
                            color: widget.isDark ? trueBack : trueText,
                            onPressed: () async {
                              if (attendenceController.text.isNotEmpty &&
                                  int.parse(attendenceController.text) < 100) {
                                await setMinAttendenceinDisk(
                                    int.parse(attendenceController.text));
                                setState(() {
                                  minAttendence =
                                      int.parse(attendenceController.text);
                                });
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              Icons.done,
                              color: widget.isDark ? trueText : Colors.white,
                            ),
                            label: Text(
                              "Done",
                              style: TextStyle(
                                  color:
                                      widget.isDark ? trueText : Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                      content: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: TextField(
                              controller: attendenceController,
                              autofocus: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24.0),
                              keyboardType: TextInputType.numberWithOptions(),
                              onSubmitted: (value) async {
                                if (attendenceController.text.isNotEmpty &&
                                    int.parse(attendenceController.text) <
                                        100) {
                                  await setMinAttendenceinDisk(
                                      int.parse(attendenceController.text));
                                  setState(() {
                                    minAttendence =
                                        int.parse(attendenceController.text);
                                  });
                                }
                              }),
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
                    color: widget.isDark ? Colors.white : trueText),
              ),
            ),
            ListTile(
              title: Text(
                "Developer",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              trailing: IconButton(
                onPressed: () {
                  _launchURL();
                },
                icon: Icon(
                  Icons.open_in_new,
                  color: widget.isDark ? Colors.white : trueText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        "Bunker",
        style: TextStyle(
            fontSize: 24.0, color: widget.isDark ? Colors.white : trueText),
      ),
      actions: <Widget>[
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.settings,
              color: widget.isDark ? Colors.white : trueText,
            ),
          ),
        )
      ],
    );
  }
}
