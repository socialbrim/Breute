// ignore: must_be_immutable
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Widget/nutritionalFacts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';
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
  String vidLink;
  String description;
  String calories;
  String recipe;
  File _image;
  bool _showForm = false;

  Future<void> save(Map nutrients) async {
    if (_image == null) {
      return;
    }
    final ref = FirebaseStorage.instance
        .ref()
        .child("RequestMeal")
        .child("${FirebaseAuth.instance.currentUser.uid}")
        .child("${DateTime.now().toString()}" + ".jpg");
    await ref.putFile(_image);

    final vals = await ref.getDownloadURL();

    ///..
    final key = FirebaseDatabase.instance
        .reference()
        .child("${widget.category}")
        .child(FirebaseAuth.instance.currentUser.uid)
        .push()
        .key;
    FirebaseDatabase.instance
        .reference()
        .child("${widget.category}")
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
      "ImageURL": vals.toString()
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
          RaisedButton.icon(
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
          RaisedButton.icon(
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showForm = !_showForm;
            });
          },
          child: Container(
            color: theme.colorPrimary,
            height: widget.height * 0.2,
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${widget.category}',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                widget.icon,
                Icon(
                  _showForm ? MdiIcons.arrowUp : MdiIcons.arrowDown,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: widget.height * 0.02,
        ),
        if (_showForm)
          Container(
            decoration: BoxDecoration(
              color: theme.colorPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            width: widget.width * 0.9,
            child: Form(
              key: widget._breakfastformKey,
              child: Column(
                children: [
                  SizedBox(
                    height: widget.height * 0.03,
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
                        child: Text(
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
                  NutritionalFacts(
                    breakfastformKey: widget._breakfastformKey,
                    submit: save,
                    key: widget.key,
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
