import 'package:flutter/material.dart';
import '../Provider/ListBloc.dart';
import "../Model/Data.dart";

final Color trueBack = Color(0xffE0F2FE);
final Color trueBackgreen = Color(0xffDEFFEC);
final Color trueText = Color(0xff004879);
final Color trueTextgrn = Color(0xff016322);
final trueBtn = Color(0xff00b549);
final Color attendedTextCom = Colors.black54;

final Color falseBack = Color(0xffFFF2E7);
final Color falseBtn = Color(0xffff5e7a);
final Color falseText = Color(0xff810016);
final Color floatingBTn = Color(0xff9ccff1);



// ignore: must_be_immutable
class AlartsetState extends StatefulWidget {
  AlartsetState({this.isDark, this.snap, this.i, this.bloc});
  final Bloc bloc;
  bool isDark;
  AsyncSnapshot<List<Data>> snap;
  int i;
  @override
  _AlartsetStateState createState() => _AlartsetStateState();
}

class _AlartsetStateState extends State<AlartsetState> {
  int localAttendence = 0;
  int localTotalClasses = 0;
  @override
  void initState() {
    setState(() {
      localAttendence = widget.snap.data[widget.i].attended;
      localTotalClasses = widget.snap.data[widget.i].totalClasses;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listEdit(widget.snap, widget.i, context);
  }

  AlertDialog listEdit(
      AsyncSnapshot<List<Data>> snap, int i, BuildContext context) {
    return AlertDialog(
        title: Text(
          "Edit ${snap.data[i].subject}",
          style: TextStyle(
              fontSize: 26.0, color: widget.isDark ? trueBack : trueText),
        ),
        content: Container(
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Attended:   ",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: widget.isDark ? Colors.white : Colors.black87),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "$localAttendence",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: widget.isDark ? trueBack : trueText),
                      ),
                      Container(
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_drop_up,
                                size: 36.0,
                              ),
                              onPressed: () {
                                if (localAttendence < localTotalClasses) {
                                  int newAttendence = localAttendence + 1;
                                  setState(() {
                                    localAttendence = newAttendence;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 36.0,
                              ),
                              onPressed: () {
                                if (localAttendence > 0) {
                                  int newattendence = localAttendence - 1;
                                  setState(() {
                                    localAttendence = newattendence;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Total Class:  ",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: widget.isDark ? Colors.white : Colors.black87),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "$localTotalClasses",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: widget.isDark ? trueBack : trueText),
                      ),
                      Container(
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_drop_up,
                                size: 36.0,
                              ),
                              onPressed: () {
                                int newTotalClasses = localTotalClasses + 1;
                                setState(() {
                                  localTotalClasses = newTotalClasses;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 36.0,
                              ),
                              onPressed: () {
                                if (localTotalClasses > localAttendence) {
                                  int newTotalClasses = localTotalClasses - 1;
                                  setState(() {
                                    localTotalClasses = newTotalClasses;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        elevation: 12.0,
        actions: <Widget>[
          OutlineButton.icon(
            label: Text("Cancel",
                style: TextStyle(
                    color: widget.isDark ? trueBack : trueText,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400)),
            borderSide: BorderSide(
              width: 2,
              color: widget.isDark ? trueBack : trueText,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: widget.isDark ? trueBack : trueText,
            ),

          ),
          FlatButton.icon(
              color: widget.isDark ? trueBack : trueText,
              onPressed: () {
                Data newData = Data(
                    id: snap.data[i].id,
                    subject: snap.data[i].subject,
                    attended: localAttendence,
                    totalClasses: localTotalClasses
                );
                widget.bloc.editOption(newData);
                widget.bloc.getData();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.done,
                color: widget.isDark ? trueText : Colors.white,
              ),
              label: Text(
                "Ok",
                style: TextStyle(
                    color: widget.isDark ? trueText : Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400),
              )),
        ]);
  }
}



class AlartForDayEdit extends StatefulWidget {
  AlartForDayEdit({this.isDark,this.attended,this.totalClasses,this.setAttended,this.setTotalDays,this.getAllvar});
  bool isDark;
  int attended=0;
  int totalClasses = 0;
  Function setAttended,setTotalDays,getAllvar;
  @override
  _AlartForDayEditState createState() => _AlartForDayEditState();
}

class _AlartForDayEditState extends State<AlartForDayEdit> {
  int localAttended = 0;
  int localTotalDays =0;

  @override
  void initState() {
    setState(() {
      localAttended = widget.attended;
      localTotalDays = widget.totalClasses;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: widget.isDark ? Brightness.dark : Brightness.light),
      child: AlertDialog(
          title: Text(
            "Edit",
            style: TextStyle(
                fontSize: 26.0, color:widget.isDark ? trueBack : trueText),
          ),
          content: Container(
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Attended:   ",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: widget.isDark ? Colors.white : Colors.black87),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "$localAttended",
                          style: TextStyle(
                              fontSize: 26.0,
                              color:widget.isDark ? trueBack : trueText),
                        ),
                        Container(
                          height: 100.0,
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  size: 36.0,
                                ),
                                onPressed: () {
                                  if (localAttended < localTotalDays) {
                                    int newAttendence = localAttended + 1;
                                    setState(() {
                                      localAttended = newAttendence;
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 36.0,
                                ),
                                onPressed: () {
                                  if (localAttended > 0) {
                                    int newattendence = localAttended - 1;
                                    setState(() {
                                      localAttended = newattendence;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Total Class:  ",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: widget.isDark ? Colors.white : Colors.black87),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "$localTotalDays",
                          style: TextStyle(
                              fontSize: 26.0,
                              color: widget.isDark ? trueBack : trueText),
                        ),
                        Container(
                          height: 100.0,
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  size: 36.0,
                                ),
                                onPressed: () {
                                  int newTotalClasses = localTotalDays + 1;
                                  setState(() {
                                    localTotalDays = newTotalClasses;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 36.0,
                                ),
                                onPressed: () {
                                  if (localTotalDays > localAttended) {
                                    int newTotalClasses = localTotalDays - 1;
                                    setState(() {
                                      localTotalDays = newTotalClasses;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          elevation: 12.0,
          actions: <Widget>[
            OutlineButton.icon(
              label: Text("Cancel",
                  style: TextStyle(
                      color: widget.isDark ? trueBack : trueText,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400)),
              borderSide: BorderSide(
                width: 2,
                color: widget.isDark ? trueBack : trueText,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: widget.isDark ? trueBack : trueText,
              ),

            ),
            FlatButton.icon(
                color: widget.isDark ? trueBack : trueText,
                onPressed: ()  async{
                  await widget.setAttended(localAttended);
                  await widget.setTotalDays(localTotalDays);
                  widget.getAllvar();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.done,
                  color: widget.isDark ? trueText : Colors.white,
                ),
                label: Text(
                  "Ok",
                  style: TextStyle(
                      color: widget.isDark ? trueText : Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400),
                )),
          ]),
    );
  }
}
