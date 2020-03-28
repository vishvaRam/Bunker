import 'package:bunker/Provider/ListBloc.dart';
import 'package:flutter/material.dart';
import './Widgets/Drawer.dart';
import './Model/Data.dart';

final Color trueBack = Color(0xffE0F2FE);
final Color trueText = Color(0xff004879);
final trueBtn = Color(0xff42b3ff);

final Color falseBack = Color(0xffFFF2E7);
final Color falseBtn = Color(0xffff5e7a);
final Color falseText = Color(0xff810016);
final Color floatingBTn = Color(0xff9ccff1);

class Periodic extends StatefulWidget {
  Periodic({this.isDark,this.setTheme,this.bloc,this.setMinAttendence,this.popupInput,this.minAttendence,this.textController});
  Function setMinAttendence;
  TextEditingController popupInput;
  TextEditingController textController;
  int minAttendence;
  bool isDark;
  Function setTheme;
  Bloc bloc;
  @override
  _PeriodicState createState() => _PeriodicState();
}

class _PeriodicState extends State<Periodic> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) => Scaffold(
          drawer: Drawer(
            child: drawerView(widget.isDark, widget.setTheme, widget.bloc,widget.minAttendence,widget.setMinAttendence,widget.popupInput),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              elevation: 12.0,
              backgroundColor: widget.isDark ? floatingBTn : trueText,
              onPressed: () {
                showbottomSheet(context, widget.textController);
              },
              child: Icon(
                Icons.add,
                color: widget.isDark ? trueText : Colors.white,
              ),
            ),
          ),
          appBar: buildAppBar(),
          body: Builder(
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<List<Data>>(
                stream: widget.bloc.listOUT,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Data>> snap) {
                  if (!snap.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snap.data.length == 0) {
                    return Center(
                      child: Text("Empty"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (BuildContext context, i) {
                      return Dismissible(
                          key: Key(snap.data[i].id.toString()),
                          onDismissed: (direction) {
                            widget.bloc.delete(snap.data[i].id);
                            widget.bloc.getData();
                          },
                          background: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 15.0),
                            child: Container(
                              color: Colors.red,
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 32.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          child: buildCards(snap, i));
                    },
                  );
                },
              ),
            ),
          ),
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
        TextStyle(fontSize: 24.0, color: widget.isDark ? Colors.white : trueText),
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

  Padding buildCards(AsyncSnapshot snap, int i) {
    int roundedPercentage = 0;
    if (snap.data[i].totalClasses != 0) {
      double percentage =
      ((snap.data[i].attended / snap.data[i].totalClasses) * 100);
      roundedPercentage = percentage.round();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: roundedPercentage < widget.minAttendence? falseBack : trueBack,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        height: 120.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Subject & button
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 15.0),
                    child: Text(
                      snap.data[i].subject,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: roundedPercentage < widget.minAttendence ? falseText : trueText),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 15.0, bottom: 8, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          color: roundedPercentage < widget.minAttendence ? falseBtn : trueBtn,
                          onPressed: () {
                            widget.bloc.attendedChange(snap.data[i]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "Attend",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          color: roundedPercentage < widget.minAttendence ? falseBtn : trueBtn,
                          onPressed: () {
                            widget.bloc.bunkChange(snap.data[i]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "Bunk",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Percentage
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: roundedPercentage == 100
                        ? EdgeInsets.only(left: 0.0, bottom: 0.0, top: 10.0)
                        : EdgeInsets.only(left: 20.0, bottom: 0.0, top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          snap.data[i].totalClasses == 0
                              ? "0"
                              : roundedPercentage.toString(),
                          style: TextStyle(
                              fontSize: 65.0,
                              color: roundedPercentage < widget.minAttendence
                                  ? falseText
                                  : trueText),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "%",
                            style: TextStyle(
                                fontSize: 26.0,
                                color: roundedPercentage <widget.minAttendence
                                    ? falseText
                                    : trueText),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "attended : ${snap.data[i].attended}/${snap.data[i].totalClasses} ",
                      style: TextStyle(color: trueText),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showbottomSheet(context, TextEditingController _textController) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return AnimatedPadding(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: widget.isDark ? Color(0xff323F4D) : Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isDark ? Color(0xff323F4D) : Colors.white,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Subject",
                        style: TextStyle(
                            color: widget.isDark? Colors.white: trueText,
                            fontSize: 32.0, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: TextField(
                        controller: _textController,
                        style: TextStyle(fontSize: 22.0),
                        decoration:
                        InputDecoration(hintText: "Type the subject"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 20.0, left: 20.0, right: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: FlatButton(
                            onPressed: () async {
                              if (_textController.text != "") {
                                Navigator.pop(context);
                                widget.bloc.addSubject(_textController.text);
                                _textController.clear();
                              }
                            },
                            color: widget.isDark? trueBtn: trueText,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
