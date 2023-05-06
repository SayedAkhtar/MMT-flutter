import 'package:get/get.dart';

class User {
  String? username;
  String? password;
  String? email;
  String? phoneNo;
  String? name;
  String? gender;
  String? country;
  String? dob;
  String? image;
  String? speciality;
  String? treatmentCountry;
  String? relationWithPatient;
  bool? isActive;
  int? userType;
  dynamic addedBy;
  String? updatedAt;
  String? createdAt;
  late int id;
  String? token;

  User(
      {this.username,
      this.password,
      this.email,
      this.phoneNo,
      this.name,
      this.gender,
      this.country,
      this.speciality,
      this.dob,
      this.isActive,
      this.userType,
      this.treatmentCountry,
      this.addedBy,
      this.updatedAt,
      this.createdAt,
      required this.id,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    email = json['email'];
    phoneNo = json['phone'].toString();
    name = json['name'];
    image = json['image'];
    gender = json['gender'];
    country = json['country'];
    dob = json['dob'];
    treatmentCountry = json['treatment_country'];
    isActive = json['is_active'];
    userType = json['user_type'];
    addedBy = json['added_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    token = json['token'];
    id = json['id']??0;
    speciality = json['speciality'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['name'] = name;
    data['gender'] = gender;
    data['treatment_country'] = treatmentCountry;
    data['is_active'] = isActive;
    data['user_type'] = userType;
    data['added_by'] = addedBy;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}


