import 'package:intl/intl.dart';

class Doctor {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  DateTime? startOfService;
  List<String>? awards;
  String? description;
  List<String>? designation;
  List<String>? qualification;
  List<Map<String, dynamic>>? faq;
  Map<String,List<DoctorTimeSlot>>? timeSlots;
  List<String>? specialization;
  int? experience;
  List<DoctorHospital>? hospitals;
  List<Map<String, dynamic>>? blogs;
  int price = 0;

  Doctor(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.image,
      this.startOfService,
      this.awards,
      this.description,
      this.designation,
      this.qualification,
      this.specialization,
      this.faq,
      this.timeSlots,
      this.price = 0,
      this.experience,
      this.hospitals,
      this.blogs});

  Doctor.fromJson(Map<String, dynamic> json) {
    // Logger().i(json);
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    startOfService = DateFormat('yyyy-MM-dd').parse(json['start_of_service']);
    awards = json['awards'].cast<String>();
    description = json['description'];
    designation = json['designation'].cast<String>();
    qualification = json['qualification'].cast<String>();
    specialization = json['specialization'].cast<String>();
    price = json['price'];
    experience = json['experience'];
    hospitals = [];
    if (json['hospitals'] != null) {
      json['hospitals'].forEach((v) {
        hospitals?.add(DoctorHospital.fromJson(v));
      });
    }
    timeSlots = {};
    if (json['time_slots'] != null && json['time_slots'].isNotEmpty) {
      json['time_slots'].forEach((String k,values) {
        List<DoctorTimeSlot> temp = [];
        values.forEach((data){
          temp.add(DoctorTimeSlot.fromJson(data));
        });
        timeSlots?[k] = temp;
      });
    }
    timeSlots = timeSlots;

    if(json['faq'] != null){
      faq = [];
      json['faq'].forEach((v){
        faq?.add(v);
      });
    }
    if(json['blogs'] != null){
      blogs = [];
      json['blogs'].forEach((v){
        blogs?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['start_of_service'] = startOfService;
    data['awards'] = awards;
    data['description'] = description;
    data['designation'] = designation;
    data['qualification'] = qualification;
    data['specialization'] = specialization;
    data['faq'] = faq;
    data['time_slots'] = timeSlots;
    data['price'] = price;
    return data;
  }
}

class DoctorHospital {
  int? id;
  String? name;
  DoctorHospital({this.id, this.name});
  DoctorHospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class DoctorTimeSlot {
  String? time;
  int? timestamp;
  DoctorTimeSlot.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    timestamp = json['utc'];
  }
}
