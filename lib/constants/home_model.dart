import 'package:mmt_/models/faq_model.dart';

class Home {
  List<Hospitals>? hospitals;
  List<DoctorsHome>? doctors;
  List<String>? banners;
  List<Faq>? faqs;
  List<Stories>? stories;

  Home({this.hospitals, this.doctors});

  Home.fromJson(Map<String, dynamic> json) {
    if (json['hospitals'] != null) {
      hospitals = <Hospitals>[];
      json['hospitals'].forEach((v) {
        hospitals?.add(Hospitals.fromJson(v));
      });
    }
    if (json['doctors'] != null) {
      doctors = <DoctorsHome>[];
      json['doctors'].forEach((v) {
        doctors?.add(DoctorsHome.fromJson(v));
      });
    }
    if(json['banners'] != null){
      banners = <String>[];
      json['banners'].forEach((v) {
        banners?.add(v);
      });
    }
    if(json['faq'] != null){
      faqs = <Faq>[];
      json['faq'].forEach((v) {
        faqs?.add(Faq.fromJson(v));
      });
    }

    if(json['stories'] != null ){
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories?.add(Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (hospitals != null) {
      data['hospitals'] = hospitals?.map((v) => v.toJson()).toList();
    }
    if (doctors != null) {
      data['doctors'] = doctors?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hospitals {
  int? id;
  String name = "";
  String address = "";
  String? description;
  String logo = "https://via.placeholder.com/640x480.png/00eeaa?text=No%20Thumbnail";

  Hospitals(
      {this.id,
      required this.name,
      required this.address,
      this.description,
      required this.logo});

  Hospitals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    logo = json['logo'] ?? "https://via.placeholder.com/640x480.png/00eeaa?text=No%20Thumbnail";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['description'] = description;
    data['logo'] = logo;

    return data;
  }
}

class DoctorsHome {
  int? id;
  String? name;
  String? avatar;
  String? exp;
  String? specialization;
  String? designation;
  DoctorsHome(
      {this.id,
      this.name,
        this.avatar,
      this.exp,
      this.designation,
      this.specialization});

  DoctorsHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    exp = json['start_of_service'];
    designation = json['designation'];
    specialization = json['specialization'];

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['designation'] = designation;
    data['start_of_service'] = exp;
    data['specialization'] = specialization;
    return data;
  }
}

class Stories{
  String? type;
  String? value;

  Stories({this.type, this.value});

  Stories.fromJson(Map<String, dynamic> json){
    type = json['type'];
    value = json['value'];
  }
}
