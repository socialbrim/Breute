import 'package:better_player/better_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/nutritionalFactsShow.dart';
import 'package:parentpreneur/main.dart';
import '../models/MealModel.dart';
import 'UpgradePlanScreen.dart';
import 'dart:math';

enum FilterOption {
  BreakFast,
  Lunch,
  Dinner,
}

class AllMeals extends StatefulWidget {
  @override
  _AllMealsState createState() => _AllMealsState();
}

class _AllMealsState extends State<AllMeals> {
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
    final data =
        await FirebaseDatabase.instance.reference().child("Meals").once();

    if (data.value != null) {
      final mapped = data.value as Map;
      mapped.forEach((key, value) {
        final maps = value as Map;
        maps.forEach((key, value) {
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
      });
    }
    setState(() {
      _filterdlist = _list;
    });
  }

  @override
  void initState() {
    fetchTodaysMeal(
      DateTime.now(),
    );
    super.initState();
  }

  bool _isAccessable = true;

  ///.... search algo start
  List<MealModel> _filteredList = [];
  List<MealModel> get copyList {
    return [..._list];
  }

  void searchAlgo() {
    _filteredList = [];
    copyList.forEach((element) {
      if (element.mealName.toLowerCase().contains(query.toLowerCase()) ||
          element.mealDes.toLowerCase().contains(query.toLowerCase()) ||
          element.type.toLowerCase().contains(query.toLowerCase()) ||
          element.nutrients
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
        // please Note not only element element ka element
        _filteredList.add(element);
      }
    });
  }

  TextEditingController _searchCtrl = new TextEditingController();
  String query;
  Widget searchWidget() {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: TextFormField(
              onChanged: (val) {
                setState(
                  () {
                    query = val;
                    if (query.length == 0) {
                      query = null;
                      _filteredList = [];
                    }
                    if (query != null) {
                      searchAlgo();
                    }
                  },
                );
              },
              controller: _searchCtrl,
              cursorColor: theme.colorPrimary,
              decoration: InputDecoration(
                hintText: "Search Meal",
                hintStyle: theme.text14,
                border: InputBorder.none,
                prefix: IconButton(
                  onPressed: () {
                    setState(() {
                      query = null;
                      _searchCtrl.text = "";
                      _filteredList = [];
                      _filterdlist = [..._list];
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    // navigate with filtered List;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SafeArea(
                          child: Scaffold(
                            appBar: AppBar(
                              title:
                                  Text("${_filteredList.length} Result Found"),
                            ),
                            body: _filteredList.isEmpty
                                ? Center(
                                    child: Text("No Result Found"),
                                  )
                                : ListView.builder(
                                    itemCount: _filteredList.length,
                                    itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        setState(() {
                                          _filterdlist = [];
                                          _filterdlist
                                              .add(_filteredList[index]);
                                        });
                                      },
                                      title: Text(
                                          "${_filteredList[index].mealName.toUpperCase()}"),
                                      subtitle: Text(
                                          "${_filteredList[index].mealDes}"),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (query != null && _filteredList.isEmpty)
          Container(
            height: 50,
            child: Center(
              child: Text("No Result Found"),
            ),
          ),
        if (_filteredList.isNotEmpty)
          Container(
            height: min(_filteredList.length * 75.0, 300),
            child: ListView.builder(
              itemCount: _filteredList.length,
              itemBuilder: (context, index) => Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        _filterdlist = [];
                        _filterdlist.add(_filteredList[index]);
                        _filteredList = [];

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      });
                    },
                    title:
                        Text("${_filteredList[index].mealName.toUpperCase()}"),
                    subtitle: Text("${_filteredList[index].mealDes}"),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
      ],
    );
  }

  ///.... search algo end

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
                title: Text('All Recipes'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          Duration(days: 15),
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: theme.darkMode
                                ? ThemeData.dark()
                                : ThemeData.light(),
                            child: child,
                          );
                        },
                      );

                      if (date != null) {
                        fetchTodaysMeal(date);
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                  PopupMenuButton(
                    onSelected: (val) {
                      print(val);
                      if (val == FilterOption.BreakFast) {
                        _filterdlist = [];
                        [..._list].forEach((element) {
                          //...
                          if (element.type.contains("BreakFast")) {
                            //..
                            _filterdlist.add(element);
                          }
                        });
                        setState(() {});
                      } else if (val == FilterOption.Lunch) {
                        _filterdlist = [];
                        [..._list].forEach((element) {
                          //...
                          if (element.type.contains("unch")) {
                            //..
                            _filterdlist.add(element);
                          }
                        });
                        setState(() {});
                      } else if (val == FilterOption.Dinner) {
                        _filterdlist = [];
                        [..._list].forEach((element) {
                          //...
                          if (element.type.contains("inner")) {
                            //..
                            print(element.type);
                            _filterdlist.add(element);
                          }
                        });
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      MdiIcons.dotsVertical,
                      color: Colors.black,
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('BreakFast'),
                        value: FilterOption.BreakFast,
                      ),
                      PopupMenuItem(
                        child: Text('Lunch'),
                        value: FilterOption.Lunch,
                      ),
                      PopupMenuItem(
                        child: Text('Dinner'),
                        value: FilterOption.Dinner,
                      ),
                    ],
                  ),
                ],
              ),
              body: _filterdlist.isEmpty
                  ? Center(
                      child: Text("No Meal Found!"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          searchWidget(),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.8,
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
                                        height: height * 0.02,
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
                                      SizedBox(
                                        height: height * 0.02,
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
