import 'package:mmt_/models/testimony_model.dart';
import 'package:mmt_/models/treatment.dart';

class Hospital {
  int? id;
  String? name;
  String? address;
  String? description;
  String? logo;
  bool? isActive;
  List<Treatment>? treatment;
  List<Testimony>? testimony;
  Hospital(
      {this.id,
      this.name,
      this.address,
      this.description,
      this.logo,
        this.treatment,
        this.testimony,
      this.isActive});

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    logo = json['logo'];
    isActive = json['is_active'];
    if (json['treatments'] != null) {
      treatment = <Treatment>[];
      json['treatments'].forEach((v) {
        treatment!.add(Treatment.fromJson(v));
      });
    }
    if (json['testimonies'] != null) {
      testimony = <Testimony>[];
      json['testimonies'].forEach((v) {
        testimony!.add(Testimony.fromJson(v));
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


