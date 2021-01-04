import 'package:flutter/material.dart';

import '../main.dart';

class NutritionalFacts extends StatefulWidget {
  @override
  _NutritionalFactsState createState() => _NutritionalFactsState();
}

class _NutritionalFactsState extends State<NutritionalFacts> {
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
                width: width * 0.07,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: "00",
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
                width: width * 0.07,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: "00",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
              Text(
                'cup (',
                style: theme.text16bold,
              ),
              Container(
                width: width * 0.07,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: theme.text16,
                  decoration: InputDecoration(
                    hintText: "00",
                    hintStyle: TextStyle(
                      color: theme.colorBackground,
                    ),
                  ),
                ),
              ),
              Text(
                'g)',
                style: theme.text16bold,
              ),
            ],
          ),
          Divider(
            color: theme.colorDefaultText,
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
