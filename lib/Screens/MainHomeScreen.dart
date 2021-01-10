import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Screens/UpgradePlanScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/DrawerWidget.dart';
import 'package:provider/provider.dart';
import '../Providers/MyPlanProvider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/stepsModel.dart';
import '../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int totalsteps;
  int achievedsteps = 0;
  double totalcalories;
  double achievedcalories = 0;
  DateTime _stepDate = DateTime.now();
  int barIndex = 0;
  List<StepsModel> _list = [];
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  bool _isAccessable = false;

  @override
  void didChangeDependencies() {
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "DashBoard" && value) {
        _isAccessable = true;
      }
      print(_isAccessable);
    });
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
        BetterPlayerConfiguration(autoPlay: false),
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
      setState(() {});
    });
  }

  void onStepCount(StepCount event) {
    print(event);
    if (this.mounted) {
      setState(() {
        achievedsteps = event.steps;
        _stepDate = event.timeStamp;
        fetchCalories();
      });
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    if (this.mounted) {
      setState(() {
        _status = event.status;
      });
    }
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return;
        },
        child: AlertDialog(
          title: Text("Device Not Supported"),
          content: Text("This device is not supported"),
          actions: [
            FlatButton(
              onPressed: () {
                exit(0);
              },
              child: Text("OK"),
            )
          ],
        ),
      ),
    );
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      // _steps = 'Step Count not available';
    });
  }

  void fetchCalories() {
    double _step = achievedsteps * 0.045;
    setState(() {
      achievedcalories = _step;
    });
    setStepsToServer();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

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
    _betterPlayerController.dispose();
    super.dispose();
  }

  void checkpermission() async {
    var status = await Permission.activityRecognition.status;
    print(status);
    if (status.isUndetermined) {}
    if (status.isGranted) {}
    if (status.isDenied) {
      final data = await Permission.activityRecognition.request();
      print(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    totalsteps = 5000;

    totalcalories = 5000;

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
                      child: Image.asset('assets/Logo.png'),
                    ),
                    centerTitle: false,
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
                          // BetterPlayer.network(
                          //   "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                          //   betterPlayerConfiguration: BetterPlayerConfiguration(
                          //     autoPlay: true,
                          //     aspectRatio: 16 / 9,
                          //   ),
                          // ),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Container(
                          height: height * 0.25,
                          child: Row(
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
                                      // percent: 0.6,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
