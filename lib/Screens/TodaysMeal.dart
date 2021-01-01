import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/MealModel.dart';

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
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) => ListTile(
            title: Text("${_list[index].type}"),
            subtitle: Text("${_list[index].mealName}"),
          ),
        ),
      ),
    );
  }
}
