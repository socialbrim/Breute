import 'package:better_player/better_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/nutritionalFactsShow.dart';
import 'package:parentpreneur/main.dart';
import '../models/MealModel.dart';
import 'UpgradePlanScreen.dart';

class TodaysSelectedMeal extends StatefulWidget {
  @override
  _TodaysSelectedMealState createState() => _TodaysSelectedMealState();
}

class _TodaysSelectedMealState extends State<TodaysSelectedMeal> {
  bool _showFacts = false;
  List<MealModel> _list = [];
  List<MealModel> _filterdlist = [];
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void fetchTodaysMeal(DateTime date) async {
    _list = [];
    final data = await FirebaseDatabase.instance
        .reference()
        .child("MyScheduledMeal")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(
          formatDate(
            date,
          ),
        )
        .once();

    if (data.value != null) {
      final mapped = data.value as Map;
      mapped.forEach((key, value) async {
        final changedData = await FirebaseDatabase.instance
            .reference()
            .child("Meals")
            .child(value)
            .child(key)
            .once();
        final mappedData = changedData.value as Map;
        if (mappedData != null) {
          _list.add(
            MealModel(
                calories: mappedData['Calories'].toString(),
                imageURL: mappedData['ImageURL'],
                mealDate: mappedData['MealDate'],
                mealDateInDateFormat: mappedData['MealDateFormat'] == null
                    ? DateTime.now()
                    : DateTime.parse(
                        mappedData['MealDateFormat']), //MealDateFormat
                mealDes: mappedData['Description'],
                mealName: mappedData['Meal Name'],
                recipe: mappedData['Recipe'],
                type: key,
                vidURL: mappedData['Video Link'],
                nutrients: mappedData['Nutrients']),
          );
        }
        setState(() {
          _filterdlist = _list;
        });
      });
    }
  }

  @override
  void initState() {
    fetchTodaysMeal(
      DateTime.now(),
    );
    super.initState();
  }

  bool _isAccessable = true;

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
                title: Text('My Meals'),
              ),
              body: _filterdlist.isEmpty
                  ? Center(
                      child: Text("No Meal Found!"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.88,
                            child: ListView.builder(
                              itemCount: _filterdlist.length,
                              itemBuilder: (context, index) => Card(
                                color: theme.colorPrimary,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Type:  ',
                                              style: theme.text16boldWhite,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${_filterdlist[index].type}',
                                              style: theme.text16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Date:  ',
                                              style: theme.text16boldWhite,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${formatDate(_filterdlist[index].mealDateInDateFormat)}',
                                              style: theme.text16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Meal Name:  ',
                                              style: theme.text16boldWhite,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${_filterdlist[index].mealName}',
                                              style: theme.text16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Meal Description:  ',
                                              style: theme.text16boldWhite,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${_filterdlist[index].mealDes}',
                                              style: theme.text16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Meal Recipe:  ',
                                              style: theme.text16boldWhite,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${_filterdlist[index].recipe}',
                                              style: theme.text16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Calories:  ',
                                              style: theme.text16boldWhite,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${_filterdlist[index].calories}',
                                              style: theme.text16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: theme.colorDefaultText,
                                          ),
                                        ),
                                        height: height * 0.2,
                                        width: width,
                                        child: Image.network(
                                          "${_filterdlist[index].imageURL}",
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
                                                        style:
                                                            GoogleFonts.roboto(
                                                          color: theme
                                                              .colorPrimary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Icon(
                                                        _showFacts
                                                            ? MdiIcons.arrowUp
                                                            : MdiIcons
                                                                .arrowDown,
                                                        color:
                                                            theme.colorPrimary,
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
                                        height: height * .01,
                                      ),

                                      _showFacts
                                          ? Container(
                                              alignment: Alignment.center,
                                              child: NutritionalFactsShow(
                                                submit: _filterdlist[index]
                                                    .nutrients,
                                              ),
                                            )
                                          : Container(),
                                      // SizedBox(
                                      //   height: height * 0.15,
                                      // )
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
