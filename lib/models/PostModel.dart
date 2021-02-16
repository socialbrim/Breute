class PostModel {
  String name;
  String caption;
  String imageURl;
  String postURL;
  int likes;
  Map comments;
  String uid;
  String postID;
  DateTime dateTime;
  Map likeIDs;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getCaption => caption;

  set setCaption(String caption) => this.caption = caption;

  String get getImageURl => imageURl;

  set setImageURl(String imageURl) => this.imageURl = imageURl;

  String get getPostURL => postURL;

  set setPostURL(String postURL) => this.postURL = postURL;

  int get getLikes => likes;

  set setLikes(int likes) => this.likes = likes;

  Map get getComments => comments;

  set setComments(Map comments) => this.comments = comments;
  PostModel({
    this.caption,
    this.comments,
    this.imageURl,
    this.likes,
    this.name,
    this.postURL,
    this.postID,
    this.uid,
    this.dateTime,
    this.likeIDs,
  });
}
