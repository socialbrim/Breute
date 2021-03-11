import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:parentpreneur/models/chatModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';
import './RoomInformation.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../Screens/social media/SocialMediaProfileScreen.dart';

// ignore: must_be_immutable
class ChatRoomGrp extends StatefulWidget {
  String chatRoomID;
  ChatRoomGrp({this.chatRoomID});
  @override
  _ChatRoomGrpState createState() => _ChatRoomGrpState();
}

class _ChatRoomGrpState extends State<ChatRoomGrp> {
  List<ChatModel> list;
  var key;
  ChatModel data;
  TextEditingController messageController = TextEditingController();
  String uid;

  String grpName;
  String grpDP; //.... mood hua to badme krenge
  bool currentUserTypeAdmin = false;

  ///... mood hua to
  void roomInformation() async {
    final data = await FirebaseDatabase.instance
        .reference()
        .child("Roomsinformation")
        .child(widget.chatRoomID)
        .once();
    final map = data.value as Map;
    grpName = map['roomName'];
    setState(() {});
  }

  void stream() {
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;

    final ref = FirebaseDatabase.instance
        .reference()
        .child("GroupChatRoom")
        .child("${widget.chatRoomID}")
        .onValue;
    ref.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      final chatdata = event.snapshot.value as Map;

      list = [];
      chatdata.forEach((key, value) {
        list.add(
          ChatModel(
            uid: value['uid'],
            message: value['message'],
            dateTime: DateTime.parse(
              value['timeStamp'],
            ),
            likes: value['Like'],
            imageURL: value['DpURL'],
            nameOfCustomer: value['Name'],
            messageID: key,
          ),
        );
      });
      setState(() {
        list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        final temp = list.reversed;
        list = [];
        temp.forEach((element) {
          list.add(element);
        });
      });
    });
  }

  UserInformation userInfo;
  initState() {
    audioModule.setCallBack((dynamic data) {
      _onEvent(data);
    });
    _initSettings();

    roomInformation();
    userInfo =
        Provider.of<UserProvider>(context, listen: false).userInformation;
    // uid = userInfo.id;
    stream();
    super.initState();
  }

  sendMessage() async {
    final filter = ProfanityFilter();
    print(filter.censor('${messageController.text}'));

    final ref = FirebaseDatabase.instance
        .reference()
        .child("GroupChatRoom")
        .child("${widget.chatRoomID}");
    final key = ref.push().key;
    ref.child(key).update({
      'message': filter.censor('${messageController.text}'),
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });
    messageController.text = '';
  }

  Widget chatMessageList() {
    return list != null
        ? Container(
            // height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
                reverse: true,
                itemCount: list.length,
                itemBuilder: (context, index) => MessageTile(
                      message: list[index].message,
                      chatRoomID: widget.chatRoomID,
                      isSendByMe: list[index].uid == userInfo.id,
                      imageURL: list[index].imageURL,
                      name: list[index].nameOfCustomer,
                      id: list[index].messageID,
                      uid: list[index].uid,
                      likes: list[index].likes == null
                          ? 0
                          : double.parse(list[index].likes),
                    )),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // bottomNavigationBar:
          // backgroundColor: Colors.blue[900],
          backgroundColor: theme.colorBackground,
          appBar: AppBar(
            title: Text('$grpName'),
            actions: [
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RoomInformation(
                      roomID: widget.chatRoomID,
                    ),
                  ));
                },
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: chatMessageList(),
              ),
              Container(
                color: theme.colorPrimary,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .69,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: TextField(
                          style: theme.text16Primary,
                          controller: messageController,
                          onChanged: (val) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Start Typing....',
                            hintStyle: theme.text16Primary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        if (messageController.text == null ||
                            messageController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Write some message!",
                              gravity: ToastGravity.BOTTOM);
                          return;
                        }
                        return sendMessage();
                      },
                      child: messageController.text == null ||
                              messageController.text == ""
                          ? Text(
                              'Type',
                              style: theme.text16boldWhite,
                            )
                          : Icon(
                              Icons.send,
                              color: theme.colorBackground,
                            ),
                    ),
                    InkWell(
                      onTap: () async {
                        await checkpermission();
                        _startRecord();
                      },
                      onDoubleTap: () {
                        _stopRecord();
                        filesaveToServer();
                      },
                      onLongPress: () {},
                      child: Icon(
                        Icons.mic,
                        color: _isRecording ? Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  //..... audio chat system started
  bool _isRecording = false;

  MedcorderAudio audioModule = new MedcorderAudio();

  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String file = "";
  var filePATH = "";

  Future _initSettings() async {
    final String result = await audioModule.checkMicrophonePermissions();
    if (result == 'OK') {
      await audioModule.setAudioSettings();
      setState(() {
        canRecord = true;
      });
    }
    return;
  }

  Future _startRecord() async {
    try {
      setState(() {
        _isRecording = true;
      });
      DateTime time = new DateTime.now();
      setState(() {
        file = time.millisecondsSinceEpoch.toString();
      });
      final String result = await audioModule.startRecord(file);
      setState(() {
        isRecord = true;
      });
      print('startRecord: ' + result);
    } catch (e) {
      file = "";
      print('startRecord: fail');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future _stopRecord() async {
    try {
      setState(() {
        _isRecording = false;
      });
      final String result = await audioModule.stopRecord();
      print('stopRecord: ' + result);
      setState(() {
        isRecord = false;
      });
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      print('stopRecord: fail');
      setState(() {
        isRecord = false;
      });
    }
  }

  void _onEvent(dynamic event) {
    print("-----------------------------------------");
    print(event);
    print("-----------------------------------------");
    filePATH = event['url'];
    if (event['code'] == 'recording') {
      double power = event['peakPowerForChannel'];
      setState(() {
        recordPower = (60.0 - power.abs().floor()).abs();
        recordPosition = event['currentTime'];
      });
    }
    if (event['code'] == 'playing') {
      String url = event['url'];
      setState(() {
        playPosition = event['currentTime'];
        isPlay = true;
      });
    }
    if (event['code'] == 'audioPlayerDidFinishPlaying') {
      setState(() {
        playPosition = 0.0;
        isPlay = false;
      });
    }
  }

  filesaveToServer() async {
    final fileName = new File(filePATH);
    final ref = FirebaseStorage.instance
        .ref()
        .child("CHatsAudio")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child("${DateTime.now()}" + ".mp3");
    await ref.putFile(fileName);

    final vals = await ref.getDownloadURL();
    print(vals);

    final reff = FirebaseDatabase.instance
        .reference()
        .child("GroupChatRoom")
        .child("${widget.chatRoomID}");
    final key = reff.push().key;
    reff.child(key).update({
      'message': vals,
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });
  }

  Future<void> checkpermission() async {
    var status = await Permission.microphone.status;
    print(status);
    if (status.isUndetermined) {
      final data = await Permission.microphone.request();
      print(status);
    }
    if (status.isGranted) {}
    if (status.isDenied) {
      // ignore: unused_local_variable
      final data = await Permission.microphone.request();
      print(status);
    }
  }

  //.... aduio chat finished
}

// ignore: must_be_immutable
class MessageTile extends StatefulWidget {
  final bool isSendByMe;
  final String message;
  final String imageURL;
  String name;
  final String id;
  double likes;
  String chatRoomID;
  String uid;
  MessageTile({
    this.uid,
    this.isSendByMe,
    this.message,
    this.imageURL,
    this.chatRoomID,
    this.name,
    this.id,
    this.likes,
  });

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  void initState() {
    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
          left: widget.isSendByMe ? MediaQuery.of(context).size.width * .2 : 24,
          right:
              widget.isSendByMe ? 24 : MediaQuery.of(context).size.width * .2),
      width: MediaQuery.of(context).size.width,
      alignment:
          widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        onDoubleTap: () {
          FirebaseDatabase.instance
              .reference()
              .child("GroupChatRoom")
              .child("${widget.chatRoomID}")
              .child(widget.id)
              .update({
            "Like": (widget.likes + 1).toString(),
          });
        },
        onLongPress: () {
          report(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorCompanion2,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: widget.isSendByMe
                              ? Radius.circular(15)
                              : Radius.circular(0),
                          bottomRight: widget.isSendByMe
                              ? Radius.circular(0)
                              : Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 15, left: 15, bottom: 10, top: 12),
                      child: widget.isSendByMe
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.name == null
                                          ? "Anonymous"
                                          : '${widget.name}',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    widget.message.contains(".mp3")
                                        ? IconButton(
                                            icon: isPlaying
                                                ? Icon(Icons.pause)
                                                : Icon(Icons.play_arrow),
                                            onPressed: () {
                                              if (isPlaying) {
                                                setState(() {
                                                  isPlaying = false;
                                                  pauseAudio();
                                                });
                                              } else {
                                                setState(() {
                                                  isPlaying = true;
                                                });
                                                play(widget.message);
                                              }
                                            })
                                        : Container(
                                            width: width * 0.5,
                                            child: Text(
                                              widget.message,
                                              textAlign: widget.isSendByMe
                                                  ? TextAlign.left
                                                  : TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                widget.message.contains(".mp3")
                                    ? slider()
                                    : Container(),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                InkWell(
                                  onTap: () {
                                    //...
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SocialMediaProfileScreen(
                                          isme: widget.uid ==
                                              FirebaseAuth
                                                  .instance.currentUser.uid,
                                          uid: widget.uid,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: widget.imageURL == null
                                        ? AssetImage("assets/unnamed.png")
                                        : NetworkImage(widget.imageURL),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(widget.id);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SocialMediaProfileScreen(
                                          isme: widget.uid ==
                                              FirebaseAuth
                                                  .instance.currentUser.uid,
                                          uid: widget.uid,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: widget.imageURL == null
                                        ? AssetImage("assets/unnamed.png")
                                        : NetworkImage(widget.imageURL),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name == null
                                          ? "Anonymous"
                                          : "${widget.name}",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: width * 0.5,
                                      child: Text(
                                        widget.message,
                                        textAlign: widget.isSendByMe
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  Align(
                    alignment: !widget.isSendByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: theme.colorCompanion3,
                      ),
                      height: height * .038,
                      width: !widget.isSendByMe ? width * .22 : width * .12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !widget.isSendByMe
                              ? GestureDetector(
                                  onTap: () {
                                    report(context);
                                  },
                                  child: Icon(
                                    MdiIcons.flag,
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width:
                                !widget.isSendByMe ? width * .015 : width * 0,
                          ),
                          GestureDetector(
                            onTap: () {
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("GroupChatRoom")
                                  .child("${widget.chatRoomID}")
                                  .child(widget.id)
                                  .update({
                                "Like": (widget.likes + 1).toString(),
                              });
                            },
                            child: loveIcon(widget.likes),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   // child: GestureDetector(
              //   //   onTap: () {
              //   //     FirebaseDatabase.instance
              //   //         .reference()
              //   //         .child("GroupChatRoom")
              //   //         .child("$chatRoomID")
              //   //         .child(id)
              //   //         .update({
              //   //       "Like": (likes + 1).toString(),
              //   //     });
              //   //   },
              //   //   child: loveIcon(likes),
              //   // ),
              // ),
              // !isSendByMe
              //     ? Positioned(
              //         top: 0,
              //         right: 5,
              //         child: GestureDetector(
              //           onTap: () {
              //             report(context);
              //           },
              //           child: Icon(
              //             MdiIcons.flag,
              //           ),
              //         ),
              //       )
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }

  bool isPlaying = false;

  Widget slider() {
    return Slider(
      activeColor: Colors.blue,
      inactiveColor: Colors.deepOrangeAccent,
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        print(value);
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  AudioPlayer audioPlayer = AudioPlayer();
  Duration _duration = new Duration();
  Duration _position = new Duration();
  static String privURL = "";
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }

  play(String url) async {
    audioPlayer.resume();
    int result = await audioPlayer.play(url);
    final data = audioPlayer.onDurationChanged;
    print(data.first);
    if (result == 1) {}
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  TextEditingController _ctrl = new TextEditingController();

  void report(BuildContext context) async {
    if (widget.name == "Admin") {
      Fluttertoast.showToast(msg: "Cannot report against admin");
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Report Against ${widget.name == null ? "Anonymous" : widget.name}",
          style: theme.text14boldPimary,
        ),
        content: TextFormField(
          controller: _ctrl,
          decoration: InputDecoration(hintText: 'Type here'),
        ),
        actions: [
          FlatButton(
            child: Text(
              "Cancel",
              style: theme.text12bold,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text(
              "Submit",
              style: theme.text12bold,
            ),
            onPressed: () {
              //...
              if (_ctrl.text == null || _ctrl.text == "") {
                Fluttertoast.showToast(msg: "Enter in field");
                return;
              }
              FirebaseDatabase.instance
                  .reference()
                  .child("Reports")
                  .child(FirebaseAuth.instance.currentUser.uid)
                  .update({
                "ReportBy": FirebaseAuth.instance.currentUser.uid,
                "Report": _ctrl.text,
              });
              Fluttertoast.showToast(
                  msg:
                      "Reported against ${widget.name == null ? "Anonymous" : widget.name}");
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Widget loveIcon(double count) {
    return Container(
      // width: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            color:
                // ?
                Colors.red
            // : Colors.grey
            ,
            size: 20,
          ),
          Text(count.toInt().toString())
        ],
      ),
    );
  }
}
