import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class ScheduleMeal extends StatefulWidget {
  @override
  _ScheduleMealState createState() => _ScheduleMealState();
}

class _ScheduleMealState extends State<ScheduleMeal> {
  TimeOfDay _scheduleTimeofBreakfast;
  TimeOfDay _scheduleTimeofLunch;
  TimeOfDay _scheduleTimeofDinner;

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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text('Schedule your meals'),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Breakfast',
                              style: GoogleFonts.ptMono(
                                color: theme.colorBackground,
                                fontSize: 24,
                              ),
                            ),
                            Icon(
                              MdiIcons.arrowDown,
                              color: theme.colorBackground,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        schedulingBreakfast();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.05,
                          width: width * 0.45,
                          color: theme.colorPrimary,
                          child: Text(
                            _scheduleTimeofBreakfast == null
                                ? 'Set Time'
                                : pmOrAm(_scheduleTimeofBreakfast),
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
              SizedBox(
                height: height * 0.02,
              ),
              Divider(
                thickness: 1.5,
                color: theme.colorCompanion,
              ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lunch',
                              style: GoogleFonts.ptMono(
                                color: theme.colorBackground,
                                fontSize: 24,
                              ),
                            ),
                            Icon(
                              MdiIcons.arrowDown,
                              color: theme.colorBackground,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        schedulingLunch();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.05,
                          width: width * 0.45,
                          color: theme.colorPrimary,
                          child: Text(
                            _scheduleTimeofLunch == null
                                ? 'Set Time'
                                : pmOrAm(_scheduleTimeofLunch),
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
              SizedBox(
                height: height * 0.02,
              ),
              Divider(
                thickness: 1.5,
                color: theme.colorCompanion,
              ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dinner',
                              style: GoogleFonts.ptMono(
                                color: theme.colorBackground,
                                fontSize: 24,
                              ),
                            ),
                            Icon(
                              MdiIcons.arrowDown,
                              color: theme.colorBackground,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        schedulingDinner();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.05,
                          width: width * 0.45,
                          color: theme.colorPrimary,
                          child: Text(
                            _scheduleTimeofDinner == null
                                ? 'Set Time'
                                : pmOrAm(_scheduleTimeofDinner),
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
              SizedBox(
                height: height * 0.07,
              ),
              GestureDetector(
                onTap: () {},
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
