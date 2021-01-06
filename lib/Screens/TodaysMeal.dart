import 'package:better_player/better_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/nutritionalFactsShow.dart';
import 'package:parentpreneur/main.dart';
import '../models/MealModel.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../Screens/UpgradePlanScreen.dart';
import '../Providers/MyPlanProvider.dart';

class TodaysMeal extends StatefulWidget {
  @override
  _TodaysMealState createState() => _TodaysMealState();
}

class _TodaysMealState extends State<TodaysMeal> {
  bool _showFacts = false;
  List<MealModel> _list = [];
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void fetchTodaysMeal() async {
    final data = await FirebaseDatabase.instance
        .reference()
        // .child("Meals")
        // .child(
        //   formatDate(
        //     DateTime.now().subtract(Duration(days: 4)),
        //   ),
        // )
        // .once();
        .child("Create Dinner")
        .child("PzoHaAIEptXMZB97aSdP9Hl29RD3")
        .once();

    if (data.value != null) {
      final mapped = data.value as Map;
      mapped.forEach((key, value) {
        _list.add(
          MealModel(
              calories: value['Calories'],
              imageURL: value['ImageURL'],
              mealDate: value['MealDate'],
              mealDateInDateFormat: value['MealDateFormat'] == null
                  ? DateTime.now()
                  : DateTime.parse(value['MealDateFormat']), //MealDateFormat
              mealDes: value['Description'],
              mealName: value['Meal Name'],
              recipe: value['Recipe'],
              type: key,
              vidURL: value['Video Link'],
              nutrients: value['Nutrients']),
        );
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchTodaysMeal();
    super.initState();
  }

  bool _isAccessable = false;

  @override
  void didChangeDependencies() {
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "Today's Meal" && value) {
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
                title: Text('Today\'s Meals'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height,
                      child: ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) => Card(
                          color: theme.colorPrimary,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date:",
                                      style: theme.text16boldWhite,
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.46,
                                      child: Text(
                                        "${formatDate(_list[index].mealDateInDateFormat)}",
                                        style: theme.text16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       "Meal Type:",
                                //       style: theme.text16boldWhite,
                                //     ),
                                //     SizedBox(
                                //       width: width * 0.03,
                                //     ),
                                //     Container(
                                //       width: width * 0.46,
                                //       child: Text(
                                //         "${_list[index].type}",
                                //         style: theme.text16,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: height * 0.015,
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Meal Name:",
                                      style: theme.text16boldWhite,
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.46,
                                      child: Text(
                                        "${_list[index].mealName}",
                                        style: theme.text16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Meal Decription:",
                                      style: theme.text16boldWhite,
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.46,
                                      child: Text(
                                        "${_list[index].mealDes}",
                                        style: theme.text16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Meal Recipe:",
                                      style: theme.text16boldWhite,
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.46,
                                      child: Text(
                                        "${_list[index].recipe}",
                                        style: theme.text16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Calories:",
                                      style: theme.text16boldWhite,
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.46,
                                      child: Text(
                                        "${_list[index].calories}",
                                        style: theme.text16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorDefaultText,
                                    ),
                                  ),
                                  height: height * 0.2,
                                  child: Image.network(
                                    "${_list[index].imageURL}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: BetterPlayer.network(
                                    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                                    betterPlayerConfiguration:
                                        BetterPlayerConfiguration(
                                      // autoPlay: true,
                                      aspectRatio: 16 / 9,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: height * 0.025,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showFacts = !_showFacts;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Card(
                                      color: theme.colorBackground,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Show Nutritonal Facts',
                                                  style: GoogleFonts.roboto(
                                                    color: theme.colorPrimary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  _showFacts
                                                      ? MdiIcons.arrowUp
                                                      : MdiIcons.arrowDown,
                                                  color: theme.colorPrimary,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                _showFacts
                                    ? NutritionalFactsShow(
                                        submit: _list[index].nutrients,
                                      )
                                    : Container(),
                                SizedBox(
                                  height: height * 0.15,
                                )
                              ],
                            ),
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
}
