import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class Day extends StatefulWidget {
  Day(this.isDark);
  bool isDark;
  @override
  _DayState createState() => _DayState();
}

final Color trueBack = Color(0xffE0F2FE);
final Color trueText = Color(0xff004879);
final trueBtn = Color(0xff42b3ff);

final Color falseBack = Color(0xffFFF2E7);
final Color falseBtn = Color(0xffff5e7a);
final Color falseText = Color(0xff810016);
final Color floatingBTn = Color(0xff9ccff1);

class _DayState extends State<Day> {
  int minAttendence = 75;
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
    setState(() {
      widget.isDark = res ?? false;
    });
  }

  // Setting int
  Future<bool> setMinAttendenceinDisk(int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Setted :"+value.toString());
    var res= prefs.setInt("minAttendence", value);
    return res;
  }

  // Getting int
  Future<int> getMinAttendence() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt("minAttendence");
    return res;
  }

  // Applying int
  getMinAttendenceFromDisk() async{
    var res = await getMinAttendence();
    print(res);
    setState(() {
      minAttendence = res ?? 75;
    });
  }


  @override
  void initState() {
    getTheme();
    getMinAttendenceFromDisk();
    super.initState();
  }

  @override
  void dispose() {
    attendenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: widget.isDark ? Brightness.dark : Brightness.light),
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(),
          drawer: Drawer(
            elevation: 9.0,
            child: Builder(
              builder: (context) => ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Center(
                        child: Text(
                          "Settings",
                          style: TextStyle(
                              fontSize: 32.0, color: widget.isDark ? Colors.white : trueText),
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
                          widget.isDark= value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(context: (context),child: AlertDialog(
                        title: Text("Min Attendence",style: TextStyle(color: widget.isDark?Colors.white:trueText),),
                        actions: <Widget>[
                          OutlineButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color:widget.isDark? trueBack:trueText,
                            ),
                            label: Text("Cancel",
                                style: TextStyle(
                                    color:widget.isDark? trueBack:trueText,
                                    fontSize: 18.0, fontWeight: FontWeight.w400)),
                          ),
                          FlatButton.icon(
                              color:widget.isDark?trueBack:trueText,
                              onPressed: () async {
                                if(attendenceController.text.isNotEmpty && int.parse(attendenceController.text)<100){
                                  await setMinAttendenceinDisk(int.parse(attendenceController.text));
                                  setState(() {
                                    minAttendence = int.parse(attendenceController.text);
                                  });
                                 Navigator.pop(context);
                                }
                              },
                              icon: Icon(Icons.done,color:widget.isDark? trueText:Colors.white,),
                              label: Text(
                                "Done",
                                style: TextStyle(
                                    color: widget.isDark? trueText:Colors.white,
                                    fontSize: 18.0, fontWeight: FontWeight.w400),
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
                              onSubmitted: (value) async{
                                if(attendenceController.text.isNotEmpty && int.parse(attendenceController.text)<100){
                                  await setMinAttendenceinDisk(int.parse(attendenceController.text));
                                  setState(() {
                                    minAttendence = int.parse(attendenceController.text);
                                  });
                                }
                              }
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
          ),
          body: Container(),
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
        style:
        TextStyle(fontSize: 24.0, color:  widget.isDark ? Colors.white : trueText),
      ),
      actions: <Widget>[
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.settings,
              color:  widget.isDark ? Colors.white : trueText,
            ),
          ),
        )
      ],
    );
  }
}
