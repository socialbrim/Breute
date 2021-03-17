import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

// ignore: must_be_immutable
class NutritionalFacts extends StatefulWidget {
  Function(Map) submit;

  NutritionalFacts({
    Key key,
    this.submit,
    @required GlobalKey<FormState> breakfastformKey,
  })  : _breakfastformKey = breakfastformKey,
        super(key: key);
  final GlobalKey<FormState> _breakfastformKey;

  @override
  _NutritionalFactsState createState() => _NutritionalFactsState();
}

class _NutritionalFactsState extends State<NutritionalFacts> {
  Map<String, String> _finishedMap = {};
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorBackground,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nutritional Facts',
            style: theme.text20bold,
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            children: [
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Quantity")) {
                      _finishedMap.remove("Quantity");
                    }
                    _finishedMap.putIfAbsent("Quantity", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 00",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
              Text(
                'servings per container',
                style: theme.text16,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Serving Size',
                style: theme.text16bold,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Container(
                width: width * 0.12,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("CupSize")) {
                      _finishedMap.remove("CupSize");
                    }
                    _finishedMap.putIfAbsent("CupSize", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: "0 cup",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
              Text(
                '   (',
                style: theme.text16bold,
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0g",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
              Text(
                ')',
                style: theme.text16bold,
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
            thickness: 3,
          ),
          Text(
            'Amount per Serving',
            textAlign: TextAlign.start,
            style: theme.text16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories',
                style: theme.text16bold,
              ),
              Container(
                width: width * 0.2,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Calories")) {
                      _finishedMap.remove("Calories");
                    }
                    _finishedMap.putIfAbsent("Calories", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 00 cal",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
            thickness: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '% Daily Value*',
                style: theme.text16bold,
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total Fat',
                    style: theme.text16bold,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Total Fat in G")) {
                          _finishedMap.remove("Total Fat in G");
                        }
                        _finishedMap.putIfAbsent(
                            "Total Fat in G", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Total Fat in %")) {
                      _finishedMap.remove("Total Fat in %");
                    }
                    _finishedMap.putIfAbsent(
                        "Total Fat in %", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.08),
                  Text(
                    'Saturated Fat',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Saturated")) {
                          _finishedMap.remove("Saturated");
                        }
                        _finishedMap.putIfAbsent(
                            "Saturated", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Saturated%")) {
                      _finishedMap.remove("Saturated%");
                    }
                    _finishedMap.putIfAbsent(
                        "Saturated%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.08),
                  Text(
                    'Trans Fat',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Trans")) {
                          _finishedMap.remove("Trans");
                        }
                        _finishedMap.putIfAbsent("Trans", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Trans%")) {
                      _finishedMap.remove("Trans%");
                    }
                    _finishedMap.putIfAbsent("Trans%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Cholesterol',
                    style: theme.text16bold,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Cholesterol")) {
                          _finishedMap.remove("Cholesterol");
                        }
                        _finishedMap.putIfAbsent(
                            "Cholesterol", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Cholesterol%")) {
                      _finishedMap.remove("Cholesterol%");
                    }
                    _finishedMap.putIfAbsent(
                        "Cholesterol%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Sodium',
                    style: theme.text16bold,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Sodium")) {
                          _finishedMap.remove("Sodium");
                        }
                        _finishedMap.putIfAbsent(
                            "Sodium", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Sodium%")) {
                      _finishedMap.remove("Sodium%");
                    }
                    _finishedMap.putIfAbsent("Sodium%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total Carbohydrate',
                    style: theme.text16bold,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Carbohydrate")) {
                          _finishedMap.remove("Carbohydrate");
                        }
                        _finishedMap.putIfAbsent(
                            "Carbohydrate", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Carbohydrate%")) {
                      _finishedMap.remove("Carbohydrate%");
                    }
                    _finishedMap.putIfAbsent(
                        "Carbohydrate%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.08),
                  Text(
                    'Dietary Fiber',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Dietary")) {
                          _finishedMap.remove("Dietary");
                        }
                        _finishedMap.putIfAbsent(
                            "Dietary", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Dietary%")) {
                      _finishedMap.remove("Dietary%");
                    }
                    _finishedMap.putIfAbsent("Dietary%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total Sugars',
                    style: theme.text16bold,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Sugars")) {
                          _finishedMap.remove("Sugars");
                        }
                        _finishedMap.putIfAbsent(
                            "Sugars", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Sugars%")) {
                      _finishedMap.remove("Sugars%");
                    }
                    _finishedMap.putIfAbsent("Sugars%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.08),
                  Text(
                    'Added Sugars',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("AddedSugars")) {
                          _finishedMap.remove("AddedSugars");
                        }
                        _finishedMap.putIfAbsent(
                            "AddedSugars", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("AddedSugars%")) {
                      _finishedMap.remove("AddedSugars%");
                    }
                    _finishedMap.putIfAbsent(
                        "AddedSugars%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Protien',
                    style: theme.text16bold,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Protien")) {
                          _finishedMap.remove("Protien");
                        }
                        _finishedMap.putIfAbsent(
                            "Protien", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey("Protien%")) {
                      _finishedMap.remove("Protien%");
                    }
                    _finishedMap.putIfAbsent("Protien%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
            thickness: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Vitamin D',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey("Vitamin")) {
                          _finishedMap.remove("Vitamin");
                        }
                        _finishedMap.putIfAbsent(
                            "Vitamin", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey(
                      "Vitamin%",
                    )) {
                      _finishedMap.remove(
                        "Vitamin%",
                      );
                    }
                    _finishedMap.putIfAbsent("Vitamin%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Calcium',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey(
                          "Calcium",
                        )) {
                          _finishedMap.remove(
                            "Calcium",
                          );
                        }
                        _finishedMap.putIfAbsent(
                            "Calcium", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey(
                      "Calcium%",
                    )) {
                      _finishedMap.remove(
                        "Calcium%",
                      );
                    }
                    _finishedMap.putIfAbsent("Calcium%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Iron',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey(
                          "Iron",
                        )) {
                          _finishedMap.remove(
                            "Iron",
                          );
                        }
                        _finishedMap.putIfAbsent("Iron", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey(
                      "Iron%",
                    )) {
                      _finishedMap.remove(
                        "Iron%",
                      );
                    }
                    _finishedMap.putIfAbsent("Iron%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Potassium',
                    style: theme.text16,
                  ),
                  Container(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: TextFormField(
                      onChanged: (val) {
                        if (_finishedMap.containsKey(
                          "Potassium",
                        )) {
                          _finishedMap.remove(
                            "Potassium",
                          );
                        }
                        _finishedMap.putIfAbsent(
                            "Potassium", () => val.toString());
                      },
                      keyboardType: TextInputType.number,
                      style: theme.text16,
                      decoration: InputDecoration(
                        hintText: " 0g",
                        hintStyle: TextStyle(
                          color: theme.colorBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
                  onChanged: (val) {
                    if (_finishedMap.containsKey(
                      "Potassium%",
                    )) {
                      _finishedMap.remove(
                        "Potassium%",
                      );
                    }
                    _finishedMap.putIfAbsent(
                        "Potassium%", () => val.toString());
                  },
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: " 0 %",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
            thickness: 3,
          ),
          SizedBox(
            height: height * 0.02,
          ),
          InkWell(
            splashColor: theme.colorCompanion,
            onTap: () async {
              if (!widget._breakfastformKey.currentState.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });
              await widget.submit(_finishedMap);
              setState(() {
                _isLoading = false;
              });
              print(_finishedMap);
            },
            child: Card(
              shadowColor: theme.colorPrimary,
              color: theme.colorBackground,
              elevation: 10,
              child: Container(
                width: 200,
                padding: EdgeInsets.all(8),
                child: _isLoading
                    ? SpinKitThreeBounce(
                        color: Colors.pink,
                        size: 20,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: theme.colorPrimary,
                            ),
                          ),
                          Icon(
                            MdiIcons.check,
                            color: theme.colorPrimary,
                          )
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }
}
