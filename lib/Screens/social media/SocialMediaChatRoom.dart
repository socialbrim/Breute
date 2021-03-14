import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Screens/social media/SocialMediaProfileScreen.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:parentpreneur/models/chatModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'package:provider/provider.dart';
import 'package:parentpreneur/main.dart';

// ignore: must_be_immutable
class SocialMediaChat extends StatefulWidget {
  String uid;
  UserInformation data;
  SocialMediaChat({this.uid, this.data});
  @override
  _SocialMediaChatState createState() => _SocialMediaChatState();
}

class _SocialMediaChatState extends State<SocialMediaChat> {
  List<ChatModel> list;
  var key;
  ChatModel data;
  TextEditingController messageController = TextEditingController();
  String uid;

  void stream() {
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;

    final ref = FirebaseDatabase.instance
        .reference()
        .child("ChatRoomPersonal")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(widget.uid)
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
            imageURL: value['DpURL'],
            messageID: key,
          ),
        );
      });
      if (this.mounted && context != null) {
        setState(() {
          list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          final temp = list.reversed;
          list = [];
          temp.forEach((element) {
            list.add(element);
          });
        });
      }
    });
  }

  UserInformation userInfo;
  initState() {
    audioModule.setCallBack((dynamic data) {
      _onEvent(data);
    });
    _initSettings();
    userInfo =
        Provider.of<UserProvider>(context, listen: false).userInformation;
    // uid = userInfo.id;
    stream();
    super.initState();
  }

  sendMessage() async {
    final filter = ProfanityFilter();
    final ref = FirebaseDatabase.instance.reference().child("ChatRoomPersonal");
    final key = ref.push().key;
    ref
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(widget.uid)
        .child(key)
        .update({
      'message': filter.censor('${messageController.text}'),
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });

    ref
        .child(widget.uid)
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(key)
        .update({
      'message': filter.censor('${messageController.text}'),
      "uid": userInfo.id,
      "timeStamp": DateTime.now().toIso8601String(),
      'Name': userInfo.name,
      "DpURL": userInfo.imageUrl,
    });

    FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(widget.uid)
        .update({"imageURL": widget.data.imageUrl, "name": widget.data.name});
    FirebaseDatabase.instance
        .reference()
        .child("PersonalChatsPersons")
        .child(widget.uid)
        .child(FirebaseAuth.instance.currentUser.uid)
        .update({"imageURL": userInfo.imageUrl, "name": userInfo.name});
    messageController.text = '';
  }

  Widget chatMessageList() {
    return list != null
        ? Container(
            child: ListView.builder(
                reverse: true,
                itemCount: list.length,
                itemBuilder: (context, index) => MessageTile(
                      message: list[index].message,
                      isSendByMe: list[index].uid == userInfo.id,
                      imageURL: list[index].imageURL,
                      name: list[index].nameOfCustomer,
                      id: list[index].messageID,
                    )),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // bottomNavigationBar:
          backgroundColor: theme.colorBackground,
          appBar: AppBar(
            // title: Text('Chat'),
            // backgroundColor: theme.colorCompanion,
            title: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SocialMediaProfileScreen(
                        uid: widget.data.id,
                        isme: false,
                      ),
                    ),
                  );
                },
                child: Text('${widget.data.name}')),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/chatBG.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
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
                        width: MediaQuery.of(context).size.width * .68,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 10,
                            bottom: 10,
                          ),
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
                              fillColor: theme.colorBackgroundDialog,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      InkWell(
                        onTap: () {
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
                                'Send',
                                style: theme.text16boldWhite,
                              )
                            : Icon(
                                Icons.send,
                                color: theme.colorBackground,
                              ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      GestureDetector(
                        onLongPressStart: (val) async {
                          setState(() {
                            isAudioSystemON = true;
                          });
                          await checkpermission();
                          _startRecord();
                        },
                        onLongPressEnd: (val) async {
                          _stopRecord();
                          //....
                          filesaveToServer();
                        },
                        child: _isSendingMessage
                            ? SpinKitCircle(
                                color: Colors.white,
                                size: 15,
                              )
                            : Icon(
                                Icons.mic,
                                color: _isRecording ? Colors.red : Colors.white,
                                size: _isRecording ? 35 : 25,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  //audio system

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
  bool isAudioSystemON = false;
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

  bool _isSendingMessage = false;
  filesaveToServer() async {
    try {
      setState(() {
        _isSendingMessage = true;
      });
      final fileName = new File(filePATH);
      final refff = FirebaseStorage.instance
          .ref()
          .child("CHatsAudio")
          .child(FirebaseAuth.instance.currentUser.uid)
          .child("${DateTime.now()}" + ".mp3");
      await refff.putFile(fileName);

      final vals = await refff.getDownloadURL();
      final ref =
          FirebaseDatabase.instance.reference().child("ChatRoomPersonal");
      final key = ref.push().key;
      ref
          .child(FirebaseAuth.instance.currentUser.uid)
          .child(widget.uid)
          .child(key)
          .update({
        'message': vals,
        "uid": userInfo.id,
        "timeStamp": DateTime.now().toIso8601String(),
        'Name': userInfo.name,
        "DpURL": userInfo.imageUrl,
      });

      ref
          .child(widget.uid)
          .child(FirebaseAuth.instance.currentUser.uid)
          .child(key)
          .update({
        'message': vals,
        "uid": userInfo.id,
        "timeStamp": DateTime.now().toIso8601String(),
        'Name': userInfo.name,
        "DpURL": userInfo.imageUrl,
      });

      setState(() {
        _isSendingMessage = false;
      });
    } catch (e) {
      setState(() {
        _isSendingMessage = false;
      });
      Fluttertoast.showToast(msg: "Something went wrong");
    }
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

  //audio system

}

// ignore: must_be_immutable
class MessageTile extends StatefulWidget {
  final bool isSendByMe;
  final String message;
  final String imageURL;
  String name;
  final String id;

  MessageTile({
    this.isSendByMe,
    this.message,
    this.imageURL,
    this.name,
    this.id,
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
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  bool isPlaying = false;

  Widget slider() {
    return Container(
      width: 210,
      child: Slider(
        activeColor: Colors.white,
        inactiveColor: theme.colorCompanion,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        },
      ),
    );
  }

  AudioPlayer audioPlayer = AudioPlayer();
  Duration _duration = new Duration();
  Duration _position = new Duration();

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }

  play(String url) async {
    audioPlayer.resume();
    int result = await audioPlayer.play(url);
    if (result == 1) {}
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
          left: widget.isSendByMe ? MediaQuery.of(context).size.width * .2 : 20,
          right:
              widget.isSendByMe ? 20 : MediaQuery.of(context).size.width * .2),
      width: MediaQuery.of(context).size.width,
      alignment:
          widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.isSendByMe
                      ? theme.colorCompanion3
                      : theme.colorCompanion,
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
                  padding:
                      EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 12),
                  child: widget.isSendByMe
                      ? Row(
                          children: [
                            widget.message.contains(".mp3")
                                ? GestureDetector(
                                    child: isPlaying
                                        ? Icon(Icons.pause)
                                        : Icon(Icons.play_arrow),
                                    onTap: () {
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                            widget.message.contains(".mp3")
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    child: slider(),
                                  )
                                : Container(),
                          ],
                        )
                      : Row(
                          children: [
                            widget.message.contains(".mp3")
                                ? GestureDetector(
                                    child: isPlaying
                                        ? Icon(Icons.pause)
                                        : Icon(Icons.play_arrow),
                                    onTap: () {
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
                            widget.message.contains(".mp3")
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    child: slider(),
                                  )
                                : Container(),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
