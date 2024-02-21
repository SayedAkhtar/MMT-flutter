import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/models/testimony_model.dart';
import 'package:MyMedTrip/models/treatment.dart';

class Hospital {
  int? id;
  String? name;
  String? address;
  String? description;
  String? logo;
  String? mapFrame;
  bool? isActive;
  List<String>? banners;
  List<Treatment>? treatment;
  List<Stories>? testimony;
  List<Doctor>? doctors;
  List<Map<String, dynamic>>? blogs;
  Hospital(
      {this.id,
      this.name,
      this.address,
      this.description,
      this.mapFrame,
      this.logo,
      this.banners,
        this.treatment,
        this.testimony,
        this.doctors,
      this.isActive, this.blogs });

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    logo = json['logo'];
    isActive = json['is_active'];
    mapFrame = json['map_frame'];
    treatment = <Treatment>[];
    if (json['treatments'] != null) {
      json['treatments'].forEach((v) {
        treatment!.add(Treatment.fromJson(v));
      });
    }
    if (json['testimonies'] != null) {
      testimony = <Stories>[];
      json['testimonies'].forEach((v) {
        testimony!.add(Stories.fromJson(v));
      });
    }
    doctors = <Doctor>[];
    if (json['doctors'] != null) {
      json['doctors'].forEach((v) {
        doctors!.add(Doctor.fromJson(v));
      });
    }
    banners = <String>[];
    if (json['banner'] != null) {
      json['banner'].forEach((v) {
        banners!.add(v.toString());
      });
    }
    blogs = [];
    if(json['blogs'] != null){
      json['blogs'].forEach((v){
        blogs?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['description'] = description;
    data['logo'] = logo;
    data['is_active'] = isActive;
    return data;
  }
}


