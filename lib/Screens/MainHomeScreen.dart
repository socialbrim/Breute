import 'package:better_player/better_player.dart';
import 'package:email_launcher/email_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:parentpreneur/Providers/HomeScreenCtrl.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/models/UserModel.dart';
import '../Screens/UpgradePlanScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';
import 'package:provider/provider.dart';
import '../Providers/MyPlanProvider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/stepsModel.dart';
import '../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int totalsteps;
  int achievedsteps = 0;
  double achievedWater = 0;
  double totalcalories;
  double achievedcalories = 0;
  DateTime _stepDate = DateTime.now();
  int barIndex = 0;
  List<StepsModel> _list = [];

  bool _isAccessable = false;

  @override
  void didChangeDependencies() {
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "DashBoard" && value) {
        _isAccessable = true;
      }
      print(_isAccessable);
    });

    final boolean = Provider.of<HomeProvider>(context).isLoaded;

    if (context != null && !boolean) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        print("yeh its working now ---------------------");
        Provider.of<HomeProvider>(context, listen: false).setBool(true);
        read();
      });
    } else if (boolean) {
      achievedWater = Provider.of<HomeProvider>(context).savedData;
    }
    super.didChangeDependencies();
  }

  void fetchLink() {
    FirebaseDatabase.instance
        .reference()
        .child("TrenndingVideoLink")
        .once()
        .then((value) {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        value.value['Link'],
      );
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );
      setState(() {
        _isLoading = false;
      });
    });
  }

  bool _isLoading = true;

  @override
  void initState() {
    checkpermission();
    final now = DateTime.now();
    _dates.add(null);
    for (int i = 7; i >= 0; i--) {
      _dates.add(DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i)));
    }
    _dates.add(null);

    hasPermissions();

    super.initState();
    fetchLink();
    initPlatformState();
    fetchLastSevenDays();
  }

  void fetchLastSevenDays() {
    FirebaseDatabase.instance
        .reference()
        .child("Users Step")
        .child(FirebaseAuth.instance.currentUser.uid)
        .onValue
        .listen((event) {
      _list = [];
      final mapped = event.snapshot.value as Map;
      if (mapped != null) {
        mapped.forEach((key, value) {
          _list.add(
            StepsModel(
              calories: value['Calories'].toString(),
              date: DateTime.parse(
                value['DateTime'],
              ),
              dateID: key,
              step: value['Steps'].toString(),
            ),
          );
        });
      }
      setState(() {
        _list.forEach((element) {
          if (element.dateID == formatDate(DateTime.now()) &&
              achievedsteps == 0) {
            achievedcalories = double.parse(element.calories);
            achievedsteps = int.parse(element.step);
          }
        });
      });
    });
  }

  void fetchCalories() {
    double _step = achievedsteps * 0.045;
    setState(() {
      achievedcalories = _step;
    });
    setStepsToServer();
  }

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  void initPlatformState() {
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (event.x > 18 || event.y > 18 || event.z > 18) {
          achievedsteps++;
          _stepDate = DateTime.now();
          fetchCalories();
        }
      });
    }));
  }

  final currentuser = FirebaseAuth.instance.currentUser;

  void setStepsToServer() {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .reference()
        .child("Users Step")
        .child(user.uid)
        .child(
          formatDate(_stepDate),
        )
        .update({
      "Steps": achievedsteps,
      "DateTime": _stepDate.toIso8601String(),
      "Calories": achievedcalories.toStringAsFixed(2),
    });
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  BetterPlayerController _betterPlayerController;

  @override
  void dispose() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _betterPlayerController.dispose();
    super.dispose();
  }

  void checkpermission() async {
    var status = await Permission.activityRecognition.status;
    print(status);
    if (status.isUndetermined) {
      final data = await Permission.activityRecognition.request();
      print(status);
    }
    if (status.isGranted) {}
    if (status.isDenied) {
      // ignore: unused_local_variable
      final data = await Permission.activityRecognition.request();
      print(status);
    }
  }

  String result = '';
  Map<DataType, List<FitData>> results = Map();
  bool permissions;

  RangeValues _dateRange = RangeValues(1, 8);
  List<DateTime> _dates = List<DateTime>();

  Future<void> read() async {
    results.clear();

    try {
      permissions = await FitKit.requestPermissions(DataType.values);
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {
        for (DataType type in DataType.values) {
          try {
            results[type] = await FitKit.read(
              type,
              dateFrom: DateTime.now().subtract(Duration(days: 1)),
              dateTo: DateTime.now(),
              limit: null,
            );
          } on UnsupportedException catch (e) {
            results[e.dataType] = [];
          }
        }

        result = 'readAll: success';
        // print(results);
        results.forEach((key, value) {
          if (key == DataType.ENERGY) {
            //..
            print(value);
            print("---------------------");
            final vals = value.first.value;
            print(vals);
            print("---------------------");
            final dataconvert = double.parse("${vals.toString()}");
            setState(() {
              achievedWater =
                  double.parse((dataconvert / 1000).toStringAsFixed(2));

              Provider.of<HomeProvider>(context, listen: false).savedData =
                  achievedWater;
              print("---------------------");
            });
            // value.forEach((element) {

            //   print(achievedWater);
            //   print("---------------------");
            // });
          }
        });
      }
    } catch (e) {
      result = 'readAll: $e';
    }

    setState(() {});
  }

  Future<void> hasPermissions() async {
    try {
      permissions = await FitKit.hasPermissions(DataType.values);
    } catch (e) {
      result = 'hasPermissions: $e';
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    totalsteps = 10000;

    totalcalories = 10000;
    var totalWater = 5;

    return _isLoading
        ? Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: theme.colorPrimary,
              ),
            ),
          )
        : !_isAccessable
            ? UpgradeplanScreen()
            : SafeArea(
                child: Scaffold(
                  backgroundColor: theme.colorBackground,
                  appBar: AppBar(
                    elevation: 6,
                    title: CircleAvatar(
                      child: currentuser.photoURL == null
                          ? Image.asset("assets/unnamed.png")
                          : Image.network(currentuser.photoURL),
                    ),
                    centerTitle: false,
                    actions: [
                      IconButton(
                          icon: Icon(MdiIcons.trophyAward),
                          onPressed: () async {
                            print(achievedsteps);
                            if (achievedsteps <= 10000) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      Text("Award unlocked at 10,000 steps."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              );
                              return;
                            }
                            final user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .userInformation;
                            Email email = Email(
                                to: ['test@gmail.com'],
                                subject: 'subject',
                                body:
                                    '$achievedsteps steps is done by ${user.name} with user id ${user.id} and want to take a reward');
                            await EmailLauncher.launch(email);
                          })
                    ],
                  ),
                  drawer: DrawerWidget(),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: BetterPlayer(
                            controller: _betterPlayerController,
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            'Completing an extra 10,000 steps each day typically burns about 2000 to 3500 extra calories each week. One pound of body fat equals 3500 calories, so depending on your weight and workout intensity, you could lose about one pound per week simply by completing an extra 10,000 steps each day.',
                            textAlign: TextAlign.left,
                            style: theme.text14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.0,
                        ),
                        Container(
                          height: height * 0.5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.033,
                                  ),
                                  Container(
                                    width: width * 0.45,
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                      color: theme.colorBackground,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'WATER',
                                              style: GoogleFonts.ptMono(
                                                color: theme.colorDefaultText,
                                                fontSize: 15,
                                              ),
                                            ),
                                            achievedsteps < totalsteps
                                                ? Icon(
                                                    MdiIcons.trendingDown,
                                                    color: theme.colorCompanion,
                                                  )
                                                : Icon(MdiIcons.trendingUp)
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        CircularPercentIndicator(
                                          radius: height * 0.1,
                                          lineWidth: 8.0,
                                          animation: true,
                                          percent: achievedWater /
                                              (totalWater < achievedWater
                                                  ? achievedWater
                                                  : totalWater),
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          center: Icon(
                                            MdiIcons.water,
                                            size: height * 0.05,
                                            color: theme.colorPrimary,
                                          ),
                                          progressColor: theme.colorPrimary,
                                          backgroundColor: theme.colorGrey,
                                        ),
                                        SizedBox(
                                          height: height * 0.022,
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: achievedWater.toString(),
                                              style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                color: theme.colorDefaultText,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' / $totalWater',
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.033,
                                  ),
                                  Container(
                                    width: width * 0.45,
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                      color: theme.colorBackground,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'CALORIES',
                                              style: GoogleFonts.ptMono(
                                                color: theme.colorDefaultText,
                                                fontSize: 15,
                                              ),
                                            ),
                                            achievedcalories < totalcalories
                                                ? Icon(
                                                    MdiIcons.trendingDown,
                                                    color: theme.colorCompanion,
                                                  )
                                                : Icon(
                                                    MdiIcons.trendingUp,
                                                    color: theme.colorCompanion,
                                                  )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        CircularPercentIndicator(
                                          radius: height * 0.1,
                                          lineWidth: 8.0,
                                          percent: achievedcalories /
                                              (totalcalories < achievedcalories
                                                  ? achievedcalories
                                                  : totalcalories),
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          center: Icon(
                                            MdiIcons.food,
                                            size: height * 0.05,
                                            color: theme.colorPrimary,
                                          ),
                                          progressColor: theme.colorPrimary,
                                          backgroundColor: theme.colorGrey,
                                        ),
                                        SizedBox(
                                          height: height * 0.022,
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: achievedcalories
                                                  .toStringAsFixed(2),
                                              style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                color: theme.colorDefaultText,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' / $totalcalories',
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width * 0.9,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'STEPS',
                                          style: GoogleFonts.ptMono(
                                            color: theme.colorDefaultText,
                                            fontSize: 15,
                                          ),
                                        ),
                                        achievedsteps < totalsteps
                                            ? Icon(
                                                MdiIcons.trendingDown,
                                                color: theme.colorCompanion,
                                              )
                                            : Icon(MdiIcons.trendingUp)
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    CircularPercentIndicator(
                                      radius: height * 0.1,
                                      lineWidth: 8.0,
                                      animation: true,
                                      percent: achievedsteps /
                                          (totalsteps < achievedsteps
                                              ? achievedsteps
                                              : totalsteps),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      center: Icon(
                                        MdiIcons.shoePrint,
                                        size: height * 0.05,
                                        color: theme.colorPrimary,
                                      ),
                                      progressColor: theme.colorPrimary,
                                      backgroundColor: theme.colorGrey,
                                    ),
                                    SizedBox(
                                      height: height * 0.022,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: achievedsteps.toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: theme.colorDefaultText,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' / $totalsteps',
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          height: height * 0.08,
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analysis',
                                style: GoogleFonts.poppins(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Last 7 Days',
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  // color: theme.colorGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.45,
                          child: ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  height: height * 0.06,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: theme.colorCompanion, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_list[index].date.day}/${_list[index].date.month}/${_list[index].date.year}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            '${DateFormat.EEEE().format(_list[index].date)}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Icon(
                                        MdiIcons.shoePrint,
                                        color: theme.colorPrimary,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        'Steps: ',
                                        style: GoogleFonts.roboto(
                                          color: theme.colorPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${_list[index].step}',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Icon(
                                        MdiIcons.food,
                                        color: theme.colorPrimary,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        'Calories: ',
                                        style: GoogleFonts.roboto(
                                          color: theme.colorPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${_list[index].calories}',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
