// ignore: must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/MyPlanProvider.dart';
import 'package:parentpreneur/Widget/nutritionalFacts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:images_picker/images_picker.dart';

// ignore: must_be_immutable
class CreateMealCard extends StatefulWidget {
  CreateMealCard({
    Key key,
    @required this.breakfastcardKey,
    @required this.height,
    @required this.width,
    @required this.breakfastback,
    @required GlobalKey<FormState> breakfastformKey,
    this.icon,
    this.category,
  })  : _breakfastformKey = breakfastformKey,
        super(key: key);

  final GlobalKey<FlipCardState> breakfastcardKey;
  final double height;
  final double width;
  bool breakfastback;
  final GlobalKey<FormState> _breakfastformKey;
  String category;
  Icon icon;

  @override
  _CreateMealCardState createState() => _CreateMealCardState();
}

class _CreateMealCardState extends State<CreateMealCard> {
  String name;
  TextEditingController namectrl = new TextEditingController();
  String vidLink;
  String description;
  String calories;
  String recipe;
  File _image;
  Map apiDetections = {};
  bool _showForm = true;
  bool _isAnalysing = false;
  String category = "Create Breakfast";

  Future<void> foodAPI(String imageURl) async {
    final resp = await http.post("https://food-vision.herokuapp.com/",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": "$imageURl"}));
    print(resp.statusCode);
    print(resp.body);
    setState(() {
      _isAnalysing = false;
    });
    final data = json.decode(resp.body) as Map;
    if (data != null && data['food'] != "") {
      apiDetections = data;
      Provider.of<MyPlanProvider>(context, listen: false)
          .setData(apiDetections);
      namectrl.text = data['food'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Dish Detected!"),
          content: Container(
            height: 200,
            width: double.maxFinite,
            child: ListView(
              children: [
                ListTile(
                  title: Text("Dish"),
                  trailing: Text("${data['food']}"),
                ),
                ListTile(
                  title: Text("Calories"),
                  trailing: Text("${data['calories']}"),
                ),
                ListTile(
                  title: Text("carbohydrates"),
                  trailing: Text("${data['carbohydrates']}"),
                ),
                ListTile(
                  title: Text("proteins"),
                  trailing: Text("${data['proteins']}"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "OK",
                  style: theme.text12bold,
                ))
          ],
        ),
      );
    }
  }

  Future<String> setToservers() async {
    setState(() {
      _isAnalysing = true;
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child("RequestMeal")
        .child("${FirebaseAuth.instance.currentUser.uid}")
        .child("${DateTime.now().toString()}" + ".jpg");
    await ref.putFile(_image);

    final vals = await ref.getDownloadURL();
    return vals;
  }

  Future<void> save(Map nutrients) async {
    ///..
    final key = FirebaseDatabase.instance
        .reference()
        .child("${category}")
        .child(FirebaseAuth.instance.currentUser.uid)
        .push()
        .key;
    FirebaseDatabase.instance
        .reference()
        .child("${category}")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(key)
        .update({
      "Nutrients": nutrients,
      "Description": description,
      "Meal Name": name,
      "Video Link": vidLink,
      "Calories": calories,
      "Recipe": recipe,
      "MealDate": DateTime.now().toIso8601String(),
      // "ImageURL": vals.toString()
    });
    print("done!");
  }

  Future<void> picker() async {
    // ignore: unused_local_variable
    File document;
    var vals;
    // ignore: unused_local_variable
    var _imagesetting = false;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Choose Image"),
        content: Text("Please choose an Image"),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("camera"),
            onPressed: () async {
              // ignore: deprecated_member_use
              vals = await ImagesPicker.openCamera(
                pickType: PickType.image,
                cropOpt: CropOption(
                  cropType: CropType.rect,
                ),
              );
              setState(() {
                _imagesetting = true;
              });
              Navigator.of(ctx).pop(true);
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.image),
            label: Text("gallery"),
            onPressed: () async {
              // ignore: deprecated_member_use
              vals = await ImagesPicker.pick(
                cropOpt: CropOption(
                  cropType: CropType.rect,
                ),
                count: 1,
                pickType: PickType.image,
              );
              setState(() {
                _imagesetting = true;
              });
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
    setState(() {
      if (vals == null) {
        return;
      }
      _image = File(vals.first.thumbPath);
    });
    if (_image == null) {
      return;
    }
    final resp = await setToservers();
    await foodAPI(resp);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showForm)
          Container(
            decoration: BoxDecoration(
              color: theme.colorPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            width: widget.width,
            child: Form(
              key: widget._breakfastformKey,
              child: Column(
                children: [
                  SizedBox(
                    height: widget.height * 0.03,
                  ),
                  Container(
                    width: 200,
                    child: DropdownButtonFormField(
                      dropdownColor: theme.colorBackground,
                      iconEnabledColor: Colors.white,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                      value: category,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      hint: Text('Select Category',
                          style: theme.text14boldWhiteShadow),
                      items: [
                        "Create Breakfast",
                        "Create Lunch",
                        "Create Dinner",
                        "Create Snacks"
                      ].map((e) {
                        return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: theme.text14,
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          category = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        // vertical: 5,
                      ),
                      // height: height * 0.06,
                      width: widget.width * 0.78,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorBackground,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        style: theme.text16boldWhite,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter in Field";
                          } else
                            return null;
                        },
                        onChanged: (val) {
                          name = val;
                        },
                        controller: namectrl,
                        decoration: InputDecoration(
                          hintText: "Enter Meal Name",
                          hintStyle: TextStyle(
                            color: theme.colorBackground,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.01,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        // vertical: 5,
                      ),
                      // height: height * 0.06,
                      width: widget.width * 0.78,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorBackground,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        style: theme.text16boldWhite,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter in Field";
                          } else
                            return null;
                        },
                        onChanged: (val) {
                          vidLink = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Video Link",
                          hintStyle: TextStyle(
                            color: theme.colorBackground,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.01,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      width: widget.width * 0.78,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorBackground,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        maxLines: 4,
                        keyboardType: TextInputType.name,
                        style: theme.text16boldWhite,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter in Field";
                          } else
                            return null;
                        },
                        onChanged: (val) {
                          description = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Description",
                          hintStyle: TextStyle(
                            color: theme.colorBackground,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.01,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        // vertical: 5,
                      ),
                      // height: height * 0.06,
                      width: widget.width * 0.78,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorBackground,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        style: theme.text16boldWhite,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter in Field";
                          } else
                            return null;
                        },
                        onChanged: (val) {
                          calories = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Calories",
                          hintStyle: TextStyle(
                            color: theme.colorBackground,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.01,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        // vertical: 5,
                      ),
                      // height: height * 0.06,
                      width: widget.width * 0.78,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorBackground,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        maxLines: 4,
                        keyboardType: TextInputType.name,
                        style: theme.text16boldWhite,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter in Field";
                          } else
                            return null;
                        },
                        onChanged: (val) {
                          recipe = val;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Recipe",
                          hintStyle: TextStyle(
                            color: theme.colorBackground,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.02,
                  ),
                  InkWell(
                    splashColor: theme.colorCompanion,
                    onTap: () {
                      picker();
                    },
                    child: Card(
                      shadowColor: theme.colorPrimary,
                      color: theme.colorBackground,
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: _isAnalysing
                            ? SpinKitChasingDots(
                                color: Colors.black,
                                size: 20,
                              )
                            : Text(
                                'Add Image',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorPrimary,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.02,
                  ),
                  if (_image != null)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorDefaultText,
                        ),
                      ),
                      height: widget.height * 0.2,
                      width: widget.width * 0.8,
                      child: Image.file(
                        _image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(
                    height: widget.height * 0.02,
                  ),
                  NutritionalFacts(
                    breakfastformKey: widget._breakfastformKey,
                    submit: save,
                    key: widget.key,
                    apiDetections: apiDetections,
                  ),
                  SizedBox(
                    height: widget.height * 0.02,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
