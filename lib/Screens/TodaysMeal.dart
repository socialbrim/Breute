import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parentpreneur/main.dart';
import '../models/MealModel.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class TodaysMeal extends StatefulWidget {
  @override
  _TodaysMealState createState() => _TodaysMealState();
}

class _TodaysMealState extends State<TodaysMeal> {
  List<MealModel> _list = [];
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void fetchTodaysMeal() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("Meals")
        .child(
          formatDate(
            DateTime.now().subtract(Duration(days: 4)),
          ),
        )
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
          ),
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
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
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Date:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                "${_list[index].mealDate}",
                                style: theme.text16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                "Meal Type:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                "${_list[index].type}",
                                style: theme.text16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                "Meal Name:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                "${_list[index].mealName}",
                                style: theme.text16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                "Meal Decription:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                "${_list[index].mealDes}",
                                style: theme.text16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                "Meal Recipe:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                "${_list[index].recipe}",
                                style: theme.text16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                "Calories:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                "${_list[index].calories}",
                                style: theme.text16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.2,
                            child: Image.network(
                              "${_list[index].imageURL}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              Text(
                                "Video Link:",
                                style: theme.text16boldWhite,
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Linkify(
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                                text: "${_list[index].vidURL}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
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
