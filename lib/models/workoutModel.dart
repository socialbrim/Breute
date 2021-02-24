import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WorkoutModel {
  String name;
  String des;
  String imageURL;
  String vidLink;
  String id;
  DateTime date;
  YoutubePlayerController controller;
  WorkoutModel(
      {this.date,
      this.des,
      this.id,
      this.imageURL,
      this.name,
      this.vidLink,
      this.controller});
}
