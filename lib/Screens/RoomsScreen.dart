import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class RoomsScreen extends StatefulWidget {
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  int index = 0;
  int choosenPlan = 0;
  bool ispublished = false;

  TimeOfDay _scheduleTime;

  Future<void> schedulingTime() async {
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
        _scheduleTime = time;
      }
    });
  }

  void _bottomSheet(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          height: height * .5,
          width: width,
          color: theme.colorBackgroundDialog,
          child: Column(
            children: [
              Text(
                '+ Create Room',
                style: theme.text16boldPrimary,
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                width: width * .9,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name of room',
                    focusColor: theme.colorPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Row(
                children: [
                  Container(
                    width: width * .4,
                    child: RadioListTile(
                        title: Text(
                          "Private",
                          style: theme.text16,
                        ),
                        activeColor: theme.colorPrimary,
                        value: 0,
                        groupValue: choosenPlan,
                        onChanged: (val) {
                          setState(() {
                            choosenPlan = val;
                          });
                        }),
                  ),
                  Container(
                    width: width * .4,
                    child: RadioListTile(
                        title: Text(
                          "Public",
                          style: theme.text16,
                        ),
                        activeColor: theme.colorPrimary,
                        value: 1,
                        groupValue: choosenPlan,
                        onChanged: (val) {
                          setState(() {
                            choosenPlan = val;
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: height * .003,
              ),
              Container(
                width: width * .9,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Create Password',
                    focusColor: theme.colorPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * .04,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: Checkbox(
                      value: ispublished,
                      activeColor: theme.colorPrimary,
                      onChanged: (val) {
                        setState(() {
                          ispublished = val;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Schedule ',
                    style: GoogleFonts.workSans(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: width * .02,
                  ),
                  ispublished == true
                      ? GestureDetector(
                          onTap: () {
                            schedulingTime();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              alignment: Alignment.center,
                              height: height * 0.04,
                              width: width * 0.3,
                              color: theme.colorPrimary,
                              child: Text(
                                _scheduleTime == null
                                    ? 'Set Time'
                                    : pmOrAm(_scheduleTime),
                                overflow: TextOverflow.ellipsis,
                                style: theme.text14boldWhite,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                height: height * .015,
              ),
              InkWell(
                onTap: () {},
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  color: theme.colorCompanion,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    child: Text(
                      ' Submit',
                      style: theme.text16boldWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .025,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Container(
                  height: 50,
                  width: width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * .04,
                      ),
                      Icon(
                        MdiIcons.magnify,
                        size: 23,
                      ),
                      SizedBox(
                        width: width * .025,
                      ),
                      Container(
                        height: 50,
                        width: width * .5,
                        child: TextFormField(
                          cursorColor: theme.colorPrimary,
                          decoration: InputDecoration(
                            hintText: "Search Rooms",
                            hintStyle: theme.text16,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * .06,
                  ),
                  Text(
                    'Scheduled Rooms',
                    style: theme.text20bold,
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: height * .25,
                width: width * .9,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: theme.colorBackgroundGray,
                      leading: Text(
                        '>',
                        style: theme.text14boldPimary,
                      ),
                      title: Text('Scheduled Rooms'),
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * .06,
                  ),
                  Text(
                    'Trending Rooms',
                    style: theme.text20bold,
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: height * .25,
                width: width * .9,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        '>',
                        style: theme.text14boldPimary,
                      ),
                      title: Text('Trending Rooms'),
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _bottomSheet(context);
                    },
                    child: Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                      color: theme.colorPrimary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.accountPlus,
                            ),
                            Text(
                              ' Create',
                              style: theme.text16boldWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * .02,
                  ),
                  Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                    color: theme.colorPrimary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 23,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.plus,
                          ),
                          Text(
                            'Join',
                            style: theme.text16boldWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
