import 'package:get/get.dart';

class LocalUser {
  String? username;
  String? password;
  String? email;
  String? phoneNo;
  String? name;
  String? gender;
  int? country;
  DateTime? dob;
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
  dynamic biometric;

  static const int TYPE_PATIENT = 1;
  static const int TYPE_DOCTOR = 4;
  static const int TYPE_HCF = 3;

  LocalUser(
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
        this.biometric,
      this.token});

  LocalUser.fromJson(Map<String, dynamic> json) {
    json.entries.forEach((element) {
      print(element.key);
      print(element.value.runtimeType);
    });

    username = json['username'];
    password = json['password'];
    email = json['email'];
    phoneNo = json['phone'].toString();
    name = json['name'];
    image = json['avatar'];
    gender = json['gender'];
    country = json['country'];
    dob = json['dob'] != null ? DateTime.parse(json['dob']): null;
    if(json["patient_details"] != null){
      treatmentCountry = json["patient_details"]['treatment_country'] != null ? json["patient_details"]['treatment_country'] : '';
    }
    else if(json["treatment_country"]){
      treatmentCountry = json["treatment_country"];
    }
    isActive = json['is_active'];
    userType = json['user_type'];
    addedBy = json['added_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    token = json['token'];
    id = json['id']??0;
    speciality = json['speciality'];
    biometric = json['local_auth' ];
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
    data['biometric'] = biometric;
    return data;
  }
}


