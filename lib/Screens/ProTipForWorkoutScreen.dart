import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:slimy_card/slimy_card.dart';
import '../models/workoutModel.dart';
import '../main.dart';
import 'package:provider/provider.dart';
import '../Screens/UpgradePlanScreen.dart';
import '../Providers/MyPlanProvider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Providers/favProvider.dart';
import 'package:http/http.dart';
import './FavWorkoutScreen.dart';

class ProTipForWorkOutScreen extends StatefulWidget {
  @override
  _ProTipForWorkOutScreenState createState() => _ProTipForWorkOutScreenState();
}

class _ProTipForWorkOutScreenState extends State<ProTipForWorkOutScreen> {
  List<WorkoutModel> _list = [];

  List<WorkoutModel> _filterdlist = [];
  bool _isLoading = true;
  bool _isAccessable = false;
  List<bool> _favList = [];
  @override
  void didChangeDependencies() {
    favFx();
    user = Provider.of<UserProvider>(context).userInformation;
    if (user.height == "0" || user.height == null || user.weight == null) {
      Fluttertoast.showToast(
        msg: "Add Height and weight to get recomended exercise",
      );
    }
    exerciseRecomendation();
    Provider.of<MyPlanProvider>(context).plan.details.forEach((key, value) {
      if (key == "Pro Tips" && value) {
        _isAccessable = true;
      }
      print(_isAccessable);
    });
    super.didChangeDependencies();
  }

  void favFx() {
    Provider.of<FavProvider>(context, listen: false).notifiers();
    final map = Provider.of<FavProvider>(context, listen: false).map;
    for (var i = 0; i < _filterdlist.length; i++) {
      _favList.fillRange(0, _filterdlist.length - 1, false);
      if (map.containsKey([_filterdlist[i].id])) {
        if (_favList.length < i) {
          _favList[i] = true;
        }
      } else {
        if (_favList.length < i) {
          _favList[i] = false;
        }
      }
      print(_favList);
      print("------------------------------------------");
    }
  }

  void fetchProTips() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("WorkoutTips")
        .once()
        .timeout(
          Duration(
            seconds: 8,
          ),
        );
    if (data.value != null) {
      final mapped = data.value as Map;
      mapped.forEach((key, value) {
        final map = value as Map;
        map.forEach((key, value) {
          _list.add(
            WorkoutModel(
              date: value['date'] == null
                  ? DateTime.now()
                  : DateTime.parse(value['date']),
              des: value['Description'],
              id: key,
              imageURL:
                  "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId("${value['VideoLink']}")}/0.jpg",
              name: value['Name'],
              vidLink: value['VideoLink'],
              controller: YoutubePlayerController(
                initialVideoId:
                    YoutubePlayer.convertUrlToId("${value['VideoLink']}"),
                flags: YoutubePlayerFlags(
                  isLive: true,
                  mute: false,
                  autoPlay: false,
                ),
              ),
            ),
          );
        });
      });
    }
    setState(() {
      _isLoading = false;
      _filterdlist = _list;
      favFx();
    });
  }

  UserInformation user;

  @override
  void initState() {
    fetchProTips();

    super.initState();
  }

  Future<void> exerciseRecomendation() async {
    final resp = await post("https://excercise-recommend.herokuapp.com/",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "feet": 5, //double.parse(user.height.split(".")[0]).toInt(),
          "inches": 10, //double.parse(user.height.split(".")[1]).toInt(),
          "weight": double.parse(user.weight).toInt(),
          "activity_level": "sedentary",
          "calories": 1500
          // user.calories == null
          //     ? 20000.toInt()
          //     : double.parse(user.calories).toInt(),
        }));
    if (resp.body == "Invalid Data") {
      print(resp.body);
      print("----------------------------------------------------");
      return;
    } else if (resp.body.contains("Fitness Level")) {
      print(resp.body);
      print("----------------------------------------------------");
      return;
    }
    print(resp.body);
    print("----------------------------------------------------");
    final data = json.decode(resp.body)['excercise_suggestions'] as Map;
    data.forEach((key, value) {
      _list.add(WorkoutModel(
        controller: YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId("${value['url']}"),
          flags: YoutubePlayerFlags(
            isLive: true,
            mute: false,
            autoPlay: false,
          ),
        ),
        date: DateTime.now(),
        des: value['description'],
        id: "$key",
        vidLink: value['url'],
        name: key,
        imageURL:
            "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId("${value['url']}")}/0.jpg",
      ));
    });
    setState(() {
      _filterdlist = _list;
    });
  }

  List<WorkoutModel> _filteredList = [];
  List<WorkoutModel> get copyList {
    return [..._list];
  }

  void searchAlgo() {
    _filteredList = [];
    copyList.forEach((element) {
      if (element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.vidLink.toLowerCase().contains(query.toLowerCase()) ||
          element.des.toString().toLowerCase().contains(query.toLowerCase())) {
        // please Note not only element element ka element
        _filteredList.add(element);
      }
    });
  }

  TextEditingController _searchCtrl = new TextEditingController();
  String query;
  Widget searchWidget() {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: TextFormField(
              onChanged: (val) {
                setState(
                  () {
                    query = val;
                    if (query.length == 0) {
                      query = null;
                      _filteredList = [];
                    }
                    if (query != null) {
                      searchAlgo();
                    }
                  },
                );
              },
              controller: _searchCtrl,
              cursorColor: theme.colorPrimary,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: theme.text14,
                border: InputBorder.none,
                prefix: IconButton(
                  onPressed: () {
                    setState(() {
                      query = null;
                      _searchCtrl.text = "";
                      _filteredList = [];
                      _filterdlist = [..._list];
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: theme.colorDefaultText,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (query != null && _filteredList.isEmpty)
          Container(
            height: 50,
            child: Center(
              child: Text("No Result Found"),
            ),
          ),
        if (_filteredList.isNotEmpty)
          Container(
            height: min(_filteredList.length * 75.0, 300),
            child: ListView.builder(
              itemCount: _filteredList.length,
              itemBuilder: (context, index) => Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        query = null;
                        _filterdlist = [];
                        _filterdlist.add(_filteredList[index]);
                        _filteredList = [];

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      });
                    },
                    title: Text("${_filteredList[index].name.toUpperCase()}"),
                    subtitle: Text(
                      "${_filteredList[index].des}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final map = Provider.of<FavProvider>(context).map;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return !_isAccessable
        ? UpgradeplanScreen()
        : Scaffold(
            backgroundColor: theme.colorBackground,
            appBar: AppBar(
              title: Text('The Gym'),
              actions: [
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FavWorkoutScreen(),
                    ));
                  },
                ),
              ],
            ),
            body: _isLoading
                ? Center(
                    child: SpinKitThreeBounce(
                      color: theme.colorPrimary,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        searchWidget(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: ListView.builder(
                            itemCount: _filterdlist.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: YoutubePlayer(
                                      controller:
                                          _filterdlist[index].controller,
                                      showVideoProgressIndicator: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.04,
                                  ),
                                  SlimyCard(
                                    color: theme.colorPrimary,
                                    width: width * 0.8,
                                    topCardHeight: height * 0.3,
                                    bottomCardHeight: height * 0.4,
                                    borderRadius: 15,
                                    topCardWidget: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Text(
                                                '${index + 1}. ',
                                                style: GoogleFonts.inter(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.5,
                                                // height: height * 0.05,
                                                child: Text(
                                                  _filterdlist[index]
                                                      .name
                                                      .toLowerCase(),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (map.containsKey(
                                                      _filterdlist[index].id)) {
                                                    Provider.of<FavProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFav(_filterdlist[
                                                            index]);
                                                  } else {
                                                    Provider.of<FavProvider>(
                                                            context,
                                                            listen: false)
                                                        .addFav(_filterdlist[
                                                            index]);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: map.containsKey(
                                                          _filterdlist[index]
                                                              .id)
                                                      ? Colors.red
                                                      : Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Container(
                                            height: height * 0.18,
                                            width: width * 0.7,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                _filterdlist[index].imageURL,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                        ],
                                      ),
                                    ),
                                    bottomCardWidget: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   children: [
                                          //     SizedBox(
                                          //       width: width * 0.03,
                                          //     ),
                                          //     Text(
                                          //       "Video Link - ",
                                          //       style: GoogleFonts.inter(
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.w700,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //     Linkify(
                                          //       onOpen: (link) async {
                                          //         if (await canLaunch(link.url)) {
                                          //           await launch(link.url);
                                          //         } else {
                                          //           throw 'Could not launch $link';
                                          //         }
                                          //       },
                                          //       text: "${_list[index].vidLink}",
                                          //       style: GoogleFonts.inter(
                                          //         fontSize: 14,
                                          //         fontStyle: FontStyle.italic,
                                          //         decoration: TextDecoration.underline,
                                          //         color: Colors.blue,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // SizedBox(
                                          //   height: height * 0.02,
                                          // ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Text(
                                                "Description",
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Icon(
                                                MdiIcons.arrowDown,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              "${_filterdlist[index].des}",
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    slimeEnabled: true,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
