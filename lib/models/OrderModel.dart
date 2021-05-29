class OrderModel {
  String orderID;
  Map orderDetails;
  String status;
  String netpayment;
  DateTime dateTime;
  Map addressMap;
  String customerName;
  String customerPhone;
  OrderModel({
    this.addressMap,
    this.customerName,
    this.customerPhone,
    this.dateTime,
    this.netpayment,
    this.orderDetails,
    this.orderID,
    this.status,
  });
}
