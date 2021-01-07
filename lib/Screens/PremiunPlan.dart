import 'package:flutter/material.dart';
import '../models/PlanDetail.dart';
import 'package:firebase_database/firebase_database.dart';

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

  @override
  void initState() {
    fetchPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: height * 0.67,
          child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) => RadioListTile(
                title: Text(
                  "${_list[index].name.toUpperCase()}",
                ),
                subtitle: Text(
                  "${_list[index].amount}",
                ),
                value: index,
                groupValue: choosenPlan,
                onChanged: (val) {
                  setState(() {
                    choosenPlan = val;
                  });
                }),
          ),
        ),
      ],
    ));
  }
}
