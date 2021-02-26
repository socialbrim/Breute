import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Config/theme.dart';
import 'package:parentpreneur/main.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isModChanging = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.1,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isModChanging = true;
              });
              Provider.of<AppThemeData>(context, listen: false)
                  .changeDarkMode();
              theme.changeDarkMode();
              Future.delayed(Duration(seconds: 2)).then((value) {
                setState(() {
                  _isModChanging = false;
                });
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.04,
                ),
                Icon(
                  MdiIcons.themeLightDark,
                  color: theme.colorPrimary,
                  size: 30,
                ),
                SizedBox(
                  width: width * 0.07,
                ),
                Container(
                  child: Text(
                    theme.darkMode ? 'Light Theme' : "Dark Theme",
                    style: theme.text16bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
