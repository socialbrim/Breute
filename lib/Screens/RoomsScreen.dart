import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class RoomsScreen extends StatefulWidget {
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  // void bottomSheet() {
  //   return Container(

  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .025,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Container(
                  height: 50,
                  width: width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * .04,
                      ),
                      Icon(
                        MdiIcons.magnify,
                        size: 23,
                      ),
                      SizedBox(
                        width: width * .025,
                      ),
                      Container(
                        height: 50,
                        width: width * .5,
                        child: TextFormField(
                          cursorColor: theme.colorPrimary,
                          decoration: InputDecoration(
                            hintText: "Search Rooms",
                            hintStyle: theme.text16,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * .06,
                  ),
                  Text(
                    'Scheduled Rooms',
                    style: theme.text20bold,
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: height * .25,
                width: width * .9,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: theme.colorBackgroundGray,
                      leading: Text(
                        '>',
                        style: theme.text14boldPimary,
                      ),
                      title: Text('Scheduled Rooms'),
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * .06,
                  ),
                  Text(
                    'Trending Rooms',
                    style: theme.text20bold,
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: height * .25,
                width: width * .9,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        '>',
                        style: theme.text14boldPimary,
                      ),
                      title: Text('Trending Rooms'),
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              FloatingActionButton(
                child: Icon(
                  MdiIcons.plus,
                ),
                onPressed: () {
                  // showBottomSheet(
                  //     context: context,
                  //     builder: (context) => Container(
                  //           height: height * .5,
                  //           color: Colors.red,
                  //         ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
