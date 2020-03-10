import 'dart:async';
import 'dart:ui';

import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:filcnaplo/Dialog/LessonDialog.dart';
import 'package:filcnaplo/Datas/Lesson.dart';
import 'package:filcnaplo/Datas/User.dart';
import 'package:filcnaplo/Datas/Week.dart';
import 'package:filcnaplo/GlobalDrawer.dart';
import 'package:filcnaplo/Helpers/TimetableHelper.dart';
import 'package:filcnaplo/Utils/ModdedTabs.dart' as MT;
import "../Utils/StringFormatter.dart";
import 'package:filcnaplo/globals.dart' as globals;

void main() {
  runApp(new MaterialApp(home: new TimeTableScreen()));
}

class TimeTableScreen extends StatefulWidget {
  @override
  TimeTableScreenState createState() => new TimeTableScreenState();
}

class TimeTableScreenState extends State<TimeTableScreen>
    with TickerProviderStateMixin {
  DateTime get now => DateTime.now();

  TabController _tabController;

  DateTime startDateText;
  Week lessonsWeek;
  bool ended = false;
  int process = 0;

  int tabLength = 7;
  int relativeWeek = 0;

  User selectedUser;
  List<User> users;

  void nextWeek() {
    _tabController.animateTo(0);
    relativeWeek++;
    refreshWeek();
  }

  void previousWeek() {
    _tabController.animateTo(0);
    relativeWeek--;
    refreshWeek();
  }

  int getInitIndex(Week week, DateTime date) {
    int index = 0;
    List<List<Lesson>> realWeek = [
      week.monday,
      week.tuesday,
      week.wednesday,
      week.thursday,
      week.friday,
      week.saturday,
      week.sunday
    ];
    for (int i = 0; i < date.weekday - 1; i++) {
      if (realWeek[i].isNotEmpty) index++;
    }
    return index;
  }

  void refreshWeek({bool first = false}) async {
    process++;
    int current = process;
    ended = false;
    DateTime startDate = now;
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1 + 7 * relativeWeek)));

    setState(() {
      lessonsWeek = null;
      startDateText = startDate;
    });

    getWeek(startDate, true, !first).then((Week week) {
      if (week.dayList().isNotEmpty && current == process)
        setState(() {
          try {
            lessonsWeek = week;
            int index = getInitIndex(lessonsWeek, now);
            _tabController = new TabController(
                vsync: this,
                length: lessonsWeek.dayList().length,
                initialIndex: first && index < week.dayList().length
                    ? index
                    : first ? week.dayList().length - 1 : 0);
          } catch (e) {
            print("[E] timeTableScreen.refreshWeek()1: " + e.toString());
          }
          ended = true;
        });
    });

    getWeek(startDate, false, !first).then((Week week) {
      if (current == process)
        setState(() {
          try {
            lessonsWeek = week;
            int index = getInitIndex(lessonsWeek, now);
            _tabController = new TabController(
                vsync: this,
                length: lessonsWeek.dayList().length,
                initialIndex: first && index < week.dayList().length
                    ? index
                    : first ? week.dayList().length - 1 : 0);
          } catch (e) {
            print("[E] timeTableScreen.refreshWeek()2: " + e.toString());
          }
          ended = true;
        });
    });
  }

  void initSelectedUser() async {
    setState(() {
      selectedUser = globals.selectedUser;
    });
  }

  @override
  void initState() {
    super.initState();

    initSelectedUser();
    startDateText = now;
    startDateText = startDateText.add(new Duration(
        days: (-1 * startDateText.weekday + 1 + 7 * relativeWeek)));
    refreshWeek(first: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    globals.context = context;
    
    return new WillPopScope(
      onWillPop: () {
        globals.screen = 0;
        Navigator.pushReplacementNamed(context, "/main");
      },
      child: new DefaultTabController(
        length: tabLength,
        child: new Scaffold(
            drawer: GDrawer(),
            appBar: new AppBar(
              title: new Text(capitalize(I18n.of(context).timetable) +
                  getTimetableText(startDateText)),
            ),
            body: new Column(
              children: <Widget>[
                new Expanded(
                  child: (ended)
                      ? (lessonsWeek != null)
                          ? (lessonsWeek.dayList().isNotEmpty)
                              ? new TabBarView(
                                  controller: _tabController,
                                  children: (lessonsWeek != null)
                                      ? lessonsWeek
                                          .dayList()
                                          .map((List<Lesson> lessonList) {
                                          return new ListView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _itemBuilderLessonList(
                                                  context, index, lessonList);
                                            },
                                            itemCount: lessonsWeek != null
                                                ? lessonList.length
                                                : 0,
                                          );
                                        }).toList()
                                      : <Widget>[
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                          new Container(
                                              child: new Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                              height: 20.0,
                                              width: 20.0),
                                        ])
                              : Center(
                                  child: Text(I18n.of(context).timetableEmpty),
                                )
                          : Container()
                      : Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
                new Container(
                  height: 54.0,
                  color: Theme.of(context).primaryColor,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new IconButton(
                        tooltip: capitalize(I18n.of(context).dateWeekPrev),
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          previousWeek();
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      new Flexible(
                        child: new SingleChildScrollView(
                          child: lessonsWeek != null
                              ? new MT.TabPageSelector(
                                  controller: _tabController,
                                  indicatorSize: 25,
                                  selectedColor: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black87
                                      : Theme.of(context)
                                          .primaryColorLight
                                          .withAlpha(180),
                                  color: Colors.black26,
                                  days: lessonsWeek.dayStrings(context),
                                )
                              : new Container(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(0),
                        ),
                      ),
                      new IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          size: 20,
                          color: Colors.white,
                        ),
                        tooltip: capitalize(I18n.of(context).dateWeekNext),
                        onPressed: () {
                          setState(() {
                            HapticFeedback.lightImpact();
                            nextWeek();
                          });
                        },
                        padding: EdgeInsets.all(0),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _itemBuilderLessonList(
      BuildContext context, int index, List<Lesson> lessonList) {
    return new ListTile(
      leading: lessonList[index].count >= 0
          ? new Text(
              lessonList[index].count.toString(),
              textScaleFactor: 2.0,
            )
          : new Text(
              "+",
              textScaleFactor: 2.0,
            ),
      title: new Text(
        lessonList[index].subject +
            (lessonList[index].isMissed
                ? " (${I18n.of(context).substitutionMissed})"
                : "") +
            (lessonList[index].depTeacher != ""
                ? " (${lessonList[index].depTeacher})"
                : ""),
        style: TextStyle(
            color: lessonList[index].isMissed
                ? Colors.red
                : lessonList[index].depTeacher != ""
                    ? Colors.deepOrange
                    : null),
      ),
      subtitle: new Text(lessonList[index].theme),
      trailing: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          lessonList[index].homework != null
              ? new Container(
                  child: new Icon(Icons.home),
                  margin: EdgeInsets.all(8),
                )
              : Container(),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(lessonList[index].room),
              new Text(getLessonRangeText(lessonList[index])),
            ],
          ),
        ],
      ),
      onTap: () {
        _lessonDialog(lessonList[index]);
      },
    );
  }

  Future<Null> _lessonDialog(Lesson lesson) async {
    return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return new HomeworkDialog(lesson);
          },
        ) ??
        false;
  }

  Future<Week> getWeek(
      DateTime startDate, bool offline, bool showErrors) async {
    List<Lesson> list;
    if (offline)
      list = await getLessonsOffline(startDate,
          startDate.add(new Duration(days: 6)), globals.selectedUser);
    else
      list = await getLessons(startDate, startDate.add(new Duration(days: 6)),
          globals.selectedUser, showErrors);

    List<Lesson> monday = new List();
    List<Lesson> tuesday = new List();
    List<Lesson> wednesday = new List();
    List<Lesson> thursday = new List();
    List<Lesson> friday = new List<Lesson>();
    List<Lesson> saturday = new List();
    List<Lesson> sunday = new List();

    setState(() {
      for (Lesson lesson in list) {
        switch (lesson.date.weekday) {
          case 1:
            monday.add(lesson);
            break;
          case 2:
            tuesday.add(lesson);
            break;
          case 3:
            wednesday.add(lesson);
            break;
          case 4:
            thursday.add(lesson);
            break;
          case 5:
            friday.add(lesson);
            break;
          case 6:
            saturday.add(lesson);
            break;
          case 7:
            sunday.add(lesson);
            break;
        }
      }
    });

    monday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    tuesday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    wednesday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    thursday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    friday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    saturday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));
    sunday.sort((Lesson a, Lesson b) => a.start.compareTo(b.start));

    return new Week(monday, tuesday, wednesday, thursday, friday, saturday,
        sunday, startDate);
  }
}
