class RoomModel {
  String name;
  String id;
  DateTime dateTime;
  String roomIDTOENTER;
  Map forSchedulesAndAll;
  String scheduleTime;

  RoomModel({
    this.name,
    this.dateTime,
    this.id,
    this.scheduleTime,
    this.forSchedulesAndAll,
    this.roomIDTOENTER,
  });
}
