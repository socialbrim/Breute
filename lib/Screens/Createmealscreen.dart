import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Widget/createmealcard.dart';

import '../main.dart';
import 'package:provider/provider.dart';
import '../Screens/UpgradePlanScreen.dart';
import '../Providers/MyPlanProvider.dart';

class CreateMealScreen extends StatefulWidget {
  @override
  _CreateMealScreenState createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends State<CreateMealScreen> {
  GlobalKey<FlipCardState> breakfastcardKey = GlobalKey<FlipCardState>();
  final _breakfastformKey = GlobalKey<FormState>();
  bool breakfastback = false;
  GlobalKey<FlipCardState> lunchcardKey = GlobalKey<FlipCardState>();
  final _lunchfastformKey = GlobalKey<FormState>();
  bool lunchback = false;
  GlobalKey<FlipCardState> dinnercardKey = GlobalKey<FlipCardState>();
  final _dinnerformKey = GlobalKey<FormState>();
  bool dinnerback = false;

  GlobalKey<FlipCardState> snackscardKey = GlobalKey<FlipCardState>();
  final _snacksformKey = GlobalKey<FormState>();
  bool snacksback = false;

  bool _isAccessable = false;

  @override
  void didChangeDependencies() {
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "Create Meal" && value) {
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
        : Scaffold(
            backgroundColor: theme.colorBackground,
            appBar: AppBar(
              title: Text('Create a Meal'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CreateMealCard(
                    category: "Create Breakfast",
                    icon: Icon(MdiIcons.fruitGrapes, color: Colors.white),
                    breakfastcardKey: breakfastcardKey,
                    height: height,
                    width: width,
                    breakfastback: breakfastback,
                    breakfastformKey: _breakfastformKey,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CreateMealCard(
                    icon: Icon(MdiIcons.foodForkDrink, color: Colors.white),
                    category: "Create Lunch",
                    breakfastcardKey: lunchcardKey,
                    height: height,
                    width: width,
                    breakfastback: lunchback,
                    breakfastformKey: _lunchfastformKey,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CreateMealCard(
                    icon: Icon(MdiIcons.foodDrumstick, color: Colors.white),
                    category: "Create Dinner",
                    breakfastcardKey: dinnercardKey,
                    height: height,
                    width: width,
                    breakfastback: dinnerback,
                    breakfastformKey: _dinnerformKey,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CreateMealCard(
                    icon: Icon(MdiIcons.foodForkDrink, color: Colors.white),
                    category: "Create Snacks",
                    breakfastcardKey: snackscardKey,
                    height: height,
                    width: width,
                    breakfastback: snacksback,
                    breakfastformKey: _snacksformKey,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                ],
              ),
            ),
          );
  }
}
