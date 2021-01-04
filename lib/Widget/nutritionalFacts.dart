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
                width: width * 0.1,
                height: height * 0.05,
                child: TextFormField(
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
        ],
      ),
    );
  }
}
