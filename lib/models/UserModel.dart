import '../models/PlanDetail.dart';

class UserInformation {
  String name;
  String email;
  String phone;
  String imageUrl;
  String bio;
  String id;
  bool isPhone;
  PlanName planDetails;
  UserInformation({
    this.email,
    this.id,
    this.imageUrl,
    this.name,
    this.phone,
    this.isPhone,
    this.planDetails,
    this.bio,
  });
}
