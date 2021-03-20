import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Screens/Payments.dart';
import '../main.dart';
import '../models/PlanDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../Providers/MyPlanProvider.dart';
import '../models/PlanDetail.dart';

class Plans extends StatefulWidget {
  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  int choosenPlan = 0;
  List<PlanName> _list = [];
  void fetchPlans() {
    FirebaseDatabase.instance
        .reference()
        .child("Plans")
        .onValue
        .listen((event) {
      _list = [];
      final mapped = event.snapshot.value as Map;
      if (mapped != null) {
        mapped.forEach((key, value) {
          //....
          _list.add(
            PlanName(
              amount: value['amount'],
              des: value['description'],
              details: value['Details'],
              name: value['Name'],
            ),
          );
        });
      }
      setState(() {});
    });
  }

  void showDial(PlanName selectedPlan) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          FlatButton(
            child: Text(
              "Close",
              style: theme.text14primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        content: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'DETAILS',
                style: theme.text20boldPrimary,
              ),
              SizedBox(
                height: height * 0.07,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Create meal',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Create Meal"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Create Meal"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Community Chat',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Community Chat"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Community Chat"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Customer Notification Schedule',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Customer Notification Schedule"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color:
                          selectedPlan.details["Customer Notification Schedule"]
                              ? Colors.green
                              : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'DashBoard',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["DashBoard"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["DashBoard"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Dual Theme',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Dual Theme"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Dual Theme"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Edit Profile',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Edit profile"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Edit profile"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Pro Tips',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Pro Tips"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Pro Tips"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Steps And Calories',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Steps And Calories"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Steps And Calories"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
              Row(
                children: [
                  Container(
                    width: width * 0.25,
                    child: Text(
                      'Today\'s Meal',
                      style: theme.text14,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.15,
                    child: Icon(
                      selectedPlan.details["Today's Meal"]
                          ? MdiIcons.check
                          : MdiIcons.close,
                      color: selectedPlan.details["Today's Meal"]
                          ? Colors.green
                          : Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                color: theme.colorGrey,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PlanName plan;
  @override
  void initState() {
    plan = Provider.of<MyPlanProvider>(context, listen: false).plan;
    fetchPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(
          title: Text(
            "Plans",
          ),
        ),
        bottomNavigationBar: Container(
          height: height * 0.07,
          color: theme.colorPrimary,
          alignment: Alignment.center,
          child: InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Free 1 Month trail Active"),
                  content: Text(
                      "${DateTime.now().day > 25 ? DateTime.now().day : 25 - DateTime.now().day} days are left in current plan"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          return;
                        },
                        child: Text(
                          "close",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              );
              Fluttertoast.showToast(
                msg:
                    "Still App will procced for testing we will remove this line after your testing",
                backgroundColor: Colors.red,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Payments(
                    plandetails: _list[choosenPlan],
                  ),
                ),
              );
            },
            child: Text(
              'Proceed To Contribute',
              style: theme.text20boldWhite,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Current Plan",
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${plan.name}",
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorPrimary,
                  ),
                  width: width,
                  height: height * 0.275,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          top: 30,
                        ),
                        child: Text(
                          'SELECT A PLAN',
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          top: 10,
                        ),
                        child: Text(
                          'Get access to premium wellness capabilities.',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        width: width * 0.8,
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/2.png',
                          height: height * 0.14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.5,
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorBackground,
                        border: Border.all(color: theme.colorDefaultText),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: RadioListTile(
                          title: Text(
                            "${_list[index].name.toUpperCase()}",
                            style: theme.text16,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "\$ ${_list[index].amount}",
                                style: theme.text16bold,
                              ),
                              SizedBox(
                                width: width * 0.2,
                              ),
                              InkWell(
                                onTap: () {
                                  showDial(_list[index]);
                                },
                                child: Container(
                                  child: Text(
                                    'Know More >',
                                    style: theme.text14primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          activeColor: theme.colorPrimary,
                          value: index,
                          groupValue: choosenPlan,
                          onChanged: (val) {
                            setState(() {
                              choosenPlan = val;
                            });
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
