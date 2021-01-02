// ignore: must_be_immutable
import 'dart:io';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

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

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: widget.breakfastcardKey,
      flipOnTouch: false,
      direction: FlipDirection.HORIZONTAL, // default
      front: InkWell(
        onTap: () {
          widget.breakfastcardKey.currentState.toggleCard();
          setState(() {
            widget.breakfastback = true;
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
                MdiIcons.arrowRight,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
      back: Card(
        shadowColor: theme.colorPrimary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: theme.colorPrimary,
              borderRadius: BorderRadius.circular(20)),
          height:
              widget.breakfastback ? widget.height * 0.85 : widget.height * 0.2,
          width: widget.width,
          child: Form(
            key: widget._breakfastformKey,
            child: SingleChildScrollView(
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
                          name = name;
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
                          vidLink = name;
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
                          description = name;
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
                          calories = name;
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
                          recipe = name;
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
                    onTap: () {},
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
                  InkWell(
                    splashColor: theme.colorCompanion,
                    onTap: () {
                      if (!widget._breakfastformKey.currentState.validate()) {
                        return;
                      }
                    },
                    child: Card(
                      shadowColor: theme.colorPrimary,
                      color: theme.colorBackground,
                      elevation: 10,
                      child: Container(
                        width: widget.width * 0.6,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'APPLY',
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
                    height: widget.height * 0.01,
                  ),
                  InkWell(
                    splashColor: theme.colorCompanion,
                    onTap: () {
                      widget.breakfastcardKey.currentState.toggleCard();
                      setState(() {
                        widget.breakfastback = false;
                      });
                    },
                    child: Card(
                      shadowColor: theme.colorPrimary,
                      color: theme.colorBackground,
                      elevation: 10,
                      child: Container(
                        width: widget.width * 0.6,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Go Back',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: theme.colorPrimary,
                              ),
                            ),
                            Icon(
                              MdiIcons.arrowLeft,
                              color: theme.colorPrimary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
