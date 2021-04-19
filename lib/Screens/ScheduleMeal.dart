import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'HomeScreen.dart';
import 'package:provider/provider.dart';
import '../Screens/UpgradePlanScreen.dart';
import '../Providers/MyPlanProvider.dart';

class ScheduleMeal extends StatefulWidget {
  @override
  _ScheduleMealState createState() => _ScheduleMealState();
}

class _ScheduleMealState extends State<ScheduleMeal> {
  TimeOfDay _scheduleTimeofBreakfast;
  TimeOfDay _scheduleTimeofLunch;
  TimeOfDay _scheduleTimeofDinner;
  TimeOfDay _scheduleTimeofSnacks1;
  TimeOfDay _scheduleTimeofSnacks2;

  Future<void> schedulingBreakfast() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 00),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    setState(() {
      if (time != null) {
        _scheduleTimeofBreakfast = time;
      }
    });
  }

  Future<void> schedulingLunch() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 00),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    setState(() {
      if (time != null) {
        _scheduleTimeofLunch = time;
      }
    });
  }

  Future<void> schedulingSnacks1() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 00),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    setState(() {
      if (time != null) {
        _scheduleTimeofSnacks1 = time;
      }
    });
  }

  Future<void> schedulingSnacks2() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 00),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    setState(() {
      if (time != null) {
        _scheduleTimeofSnacks2 = time;
      }
    });
  }

  Future<void> schedulingDinner() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 00),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    setState(() {
      if (time != null) {
        _scheduleTimeofDinner = time;
      }
    });
  }

  void fetchPriv() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("CustomSchedule")
        .child(FirebaseAuth.instance.currentUser.uid)
        .once();
    if (data.value != null) {
      if (data.value['Morning'] != null) {
        final splits = data.value['Morning']['Time'].split(":");
        _scheduleTimeofBreakfast = TimeOfDay(
          hour: int.parse(splits[0]),
          minute: int.parse(splits[1]),
        );
      }
      if (data.value['AfterNoon'] != null) {
        final splits = data.value['AfterNoon']['Time'].split(":");
        _scheduleTimeofLunch = TimeOfDay(
          hour: int.parse(splits[0]),
          minute: int.parse(splits[1]),
        );
      }
      if (data.value['Eve'] != null) {
        final splits = data.value['Eve']['Time'].split(":");
        _scheduleTimeofDinner = TimeOfDay(
          hour: int.parse(splits[0]),
          minute: int.parse(splits[1]),
        );
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchPriv();
    super.initState();
  }

  bool _isAccessable = false;

  @override
  void didChangeDependencies() {
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "Customer Notification Schedule" && value) {
        _isAccessable = true;
      }
      print(_isAccessable);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return !_isAccessable
        ? UpgradeplanScreen()
        : SafeArea(
            child: Scaffold(
              backgroundColor: theme.colorBackground,
              appBar: AppBar(
                title: Text('Meal Scheduling'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Breakfast',
                                    style: GoogleFonts.ptMono(
                                      color: theme.colorBackground,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          schedulingBreakfast();
                                        },
                                        child: InkWell(
                                          child: Text(
                                            _scheduleTimeofBreakfast == null
                                                ? 'Set Time'
                                                : pmOrAm(
                                                    _scheduleTimeofBreakfast),
                                            // textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.text14boldWhite,
                                          ),
                                        ),
                                      ),
                                      if (_scheduleTimeofBreakfast != null)
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _scheduleTimeofBreakfast = null;
                                            setState(() {});
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child("CustomSchedule")
                                                .child(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update(
                                              {
                                                "Morning":
                                                    _scheduleTimeofBreakfast ==
                                                            null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofBreakfast.hour}:${_scheduleTimeofBreakfast.minute}"
                                                          },
                                                "AfterNoon":
                                                    _scheduleTimeofLunch == null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofLunch.hour}:${_scheduleTimeofLunch.minute}"
                                                          },
                                                "Eve": _scheduleTimeofDinner ==
                                                        null
                                                    ? null
                                                    : {
                                                        "Time":
                                                            "${_scheduleTimeofDinner.hour}:${_scheduleTimeofDinner.minute}"
                                                      },
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Divider(
                      thickness: 1.5,
                      color: theme.colorCompanion,
                    ),
                    //.....
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Snack',
                                    style: GoogleFonts.ptMono(
                                      color: theme.colorBackground,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          schedulingSnacks1();
                                        },
                                        child: Text(
                                          _scheduleTimeofSnacks1 == null
                                              ? 'Set Time'
                                              : pmOrAm(_scheduleTimeofSnacks1),
                                          // textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.text14boldWhite,
                                        ),
                                      ),
                                      if (_scheduleTimeofSnacks1 != null)
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _scheduleTimeofSnacks1 = null;
                                            setState(() {});
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child("CustomSchedule")
                                                .child(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update(
                                              {
                                                "Morning":
                                                    _scheduleTimeofBreakfast ==
                                                            null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofBreakfast.hour}:${_scheduleTimeofBreakfast.minute}"
                                                          },
                                                "AfterNoon":
                                                    _scheduleTimeofLunch == null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofLunch.hour}:${_scheduleTimeofLunch.minute}"
                                                          },
                                                "Eve": _scheduleTimeofDinner ==
                                                        null
                                                    ? null
                                                    : {
                                                        "Time":
                                                            "${_scheduleTimeofDinner.hour}:${_scheduleTimeofDinner.minute}"
                                                      },
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),
                    Divider(
                      thickness: 1.5,
                      color: theme.colorCompanion,
                    ),

                    //.....

                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lunch',
                                    style: GoogleFonts.ptMono(
                                      color: theme.colorBackground,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          schedulingLunch();
                                        },
                                        child: Text(
                                          _scheduleTimeofLunch == null
                                              ? 'Set Time'
                                              : pmOrAm(_scheduleTimeofLunch),
                                          // textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.text14boldWhite,
                                        ),
                                      ),
                                      if (_scheduleTimeofLunch != null)
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _scheduleTimeofLunch = null;
                                            setState(() {});
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child("CustomSchedule")
                                                .child(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update(
                                              {
                                                "Morning":
                                                    _scheduleTimeofBreakfast ==
                                                            null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofBreakfast.hour}:${_scheduleTimeofBreakfast.minute}"
                                                          },
                                                "AfterNoon":
                                                    _scheduleTimeofLunch == null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofLunch.hour}:${_scheduleTimeofLunch.minute}"
                                                          },
                                                "Eve": _scheduleTimeofDinner ==
                                                        null
                                                    ? null
                                                    : {
                                                        "Time":
                                                            "${_scheduleTimeofDinner.hour}:${_scheduleTimeofDinner.minute}"
                                                      },
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),
                    Divider(
                      thickness: 1.5,
                      color: theme.colorCompanion,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Snack',
                                    style: GoogleFonts.ptMono(
                                      color: theme.colorBackground,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          schedulingSnacks2();
                                        },
                                        child: Text(
                                          _scheduleTimeofSnacks2 == null
                                              ? 'Set Time'
                                              : pmOrAm(_scheduleTimeofSnacks2),
                                          // textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.text14boldWhite,
                                        ),
                                      ),
                                      if (_scheduleTimeofSnacks2 != null)
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _scheduleTimeofSnacks2 = null;
                                            setState(() {});
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child("CustomSchedule")
                                                .child(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update(
                                              {
                                                "Morning":
                                                    _scheduleTimeofBreakfast ==
                                                            null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofBreakfast.hour}:${_scheduleTimeofBreakfast.minute}"
                                                          },
                                                "AfterNoon":
                                                    _scheduleTimeofLunch == null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofLunch.hour}:${_scheduleTimeofLunch.minute}"
                                                          },
                                                "Eve": _scheduleTimeofDinner ==
                                                        null
                                                    ? null
                                                    : {
                                                        "Time":
                                                            "${_scheduleTimeofDinner.hour}:${_scheduleTimeofDinner.minute}"
                                                      },
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    //
                    Divider(
                      thickness: 1.5,
                      color: theme.colorCompanion,
                    ),
                    //....
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dinner',
                                    style: GoogleFonts.ptMono(
                                      color: theme.colorBackground,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          schedulingDinner();
                                        },
                                        child: Text(
                                          _scheduleTimeofDinner == null
                                              ? 'Set Time'
                                              : pmOrAm(_scheduleTimeofDinner),
                                          // textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.text14boldWhite,
                                        ),
                                      ),
                                      if (_scheduleTimeofDinner != null)
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _scheduleTimeofDinner = null;
                                            setState(() {});
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child("CustomSchedule")
                                                .child(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update(
                                              {
                                                "Morning":
                                                    _scheduleTimeofBreakfast ==
                                                            null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofBreakfast.hour}:${_scheduleTimeofBreakfast.minute}"
                                                          },
                                                "AfterNoon":
                                                    _scheduleTimeofLunch == null
                                                        ? null
                                                        : {
                                                            "Time":
                                                                "${_scheduleTimeofLunch.hour}:${_scheduleTimeofLunch.minute}"
                                                          },
                                                "Eve": _scheduleTimeofDinner ==
                                                        null
                                                    ? null
                                                    : {
                                                        "Time":
                                                            "${_scheduleTimeofDinner.hour}:${_scheduleTimeofDinner.minute}"
                                                      },
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseDatabase.instance
                            .reference()
                            .child("CustomSchedule")
                            .child(FirebaseAuth.instance.currentUser.uid)
                            .update(
                          {
                            "Morning": _scheduleTimeofBreakfast == null
                                ? null
                                : {
                                    "Time":
                                        "${_scheduleTimeofBreakfast.hour}:${_scheduleTimeofBreakfast.minute}"
                                  },
                            "AfterNoon": _scheduleTimeofLunch == null
                                ? null
                                : {
                                    "Time":
                                        "${_scheduleTimeofLunch.hour}:${_scheduleTimeofLunch.minute}"
                                  },
                            "Eve": _scheduleTimeofDinner == null
                                ? null
                                : {
                                    "Time":
                                        "${_scheduleTimeofDinner.hour}:${_scheduleTimeofDinner.minute}"
                                  },
                          },
                        );
                        Fluttertoast.showToast(msg: "Your Schedules are fixed");
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => route.isFirst);
                      },
                      child: Card(
                        shadowColor: theme.colorPrimary,
                        elevation: 14,
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.05,
                          width: width * 0.45,
                          color: theme.colorPrimary,
                          child: Text(
                            "SUBMIT",
                            // textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: theme.text14boldWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  String pmOrAm(TimeOfDay _time) {
    final time = "${_time.hour}:${_time.minute}";
    final data = time.split(":");
    var val = int.parse(data[0]);
    var pmORAm = "AM";
    if (val > 12) {
      val = val - 12;
      pmORAm = "PM";
    } else if (val == 0) {
      val = val + 12;
    } else if (val == 12) {
      pmORAm = "PM";
    }
    var min = int.parse(data[1]);
    String zero;
    String aZero;
    val < 12
        ? val > 9
            ? zero = ""
            : zero = ""
        : zero = "";
    min < 10 ? aZero = "0" : aZero = "";
    return "$zero$val:$aZero${data[1]} $pmORAm";
  }
}
