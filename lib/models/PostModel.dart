class PostModel {
  String name;
  String caption;
  String imageURl;
  String postURL;
  int likes;
  Map comments;
  PostModel({
    this.caption,
    this.comments,
    this.imageURl,
    this.likes,
    this.name,
    this.postURL,
  });
}
