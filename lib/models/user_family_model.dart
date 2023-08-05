import 'package:MyMedTrip/helper/Utils.dart';
import 'package:get/get.dart';

class UserFamily {
  int? id;
  String? phoneNo;
  String? name;
  String? gender;
  DateTime? dob;
  String? treatmentCountry;
  String? relationWithPatient;
  String? speciality;

  static const int TYPE_PATIENT = 1;
  static const int TYPE_DOCTOR = 4;
  static const int TYPE_HCF = 3;

  UserFamily(
      {
      this.phoneNo,
      this.name,
      this.gender,
      this.dob,
      this.treatmentCountry,
      });

  UserFamily.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNo = json['phone'].toString();
    name = json['name'];
    gender = json['gender'];
    dob = json['dob'] != null ? DateTime.parse(json['dob']): null;
    treatmentCountry = json["treatment_country"];
    relationWithPatient = json['relationship'];
    speciality = json['speciality'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender;
    data['treatment_country'] = treatmentCountry;
    data['phone'] = phoneNo;
    data['relationship'] = relationWithPatient;
    data['speciality'] = speciality;
    data['dob'] = Utils.formatDate(dob);
    return data;
  }
}

