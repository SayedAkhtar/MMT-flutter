class Doctor {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  String? startOfService;
  String? awards;
  String? description;
  String? designation;
  String? qualification;
  String? faq;
  List<DoctorTimeSlot>? timeSlots;
  String? specialization;
  int? experience;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? addedBy;
  Null? updatedBy;
  List<DoctorHospital>? hospitals;
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
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.addedBy,
        this.updatedBy});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    startOfService = json['start_of_service'];
    awards = json['awards'];
    description = json['description'];
    designation = json['designation'];
    qualification = json['qualification'];
    specialization = json['specialization'];
    faq = json['faq'];
    price = json['price'];
    experience = json['experience'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addedBy = json['added_by'];
    updatedBy = json['updated_by'];
    json['hospitals'].forEach((v){
      hospitals = [];
      hospitals?.add(new DoctorHospital.fromJson(v));
    });
    timeSlots = [];
    json['time_slots'].forEach((v){
      timeSlots?.add(new DoctorTimeSlot.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['start_of_service'] = this.startOfService;
    data['awards'] = this.awards;
    data['description'] = this.description;
    data['designation'] = this.designation;
    data['qualification'] = this.qualification;
    data['specialization'] = this.specialization;
    data['faq'] = this.faq;
    data['time_slots'] = this.timeSlots;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['added_by'] = this.addedBy;
    data['updated_by'] = this.updatedBy;
    data['price'] = this.price;
    return data;
  }
}
class DoctorHospital{
  int? id;
  String? name;
  DoctorHospital({this.id, this.name});
  DoctorHospital.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class DoctorTimeSlot{
  String? dayName;
  int? timestamp;
  DoctorTimeSlot.fromJson(Map<String, dynamic> json){
    dayName = json['name'];
    timestamp = json['utc'];
  }
}
