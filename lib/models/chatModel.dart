class ChatModel {
  final String uid;
  final String message;
  final DateTime dateTime;
  final String nameOfCustomer;
  final String imageURL;

  ChatModel(
      {this.uid,
      this.message,
      this.dateTime,
      this.nameOfCustomer,
      this.imageURL});
}
