
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
  int? id;
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
      this.treatmentCountry,
      required this.id,
        this.biometric,
      this.token});

  LocalUser.fromJson(Map<String, dynamic> json) {
    // json.entries.forEach((element) {
    //   print(element.key);
    //   print(element.value.runtimeType);
    // });
    try{
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
        treatmentCountry = json["patient_details"]['treatment_country'] ?? '';
      }
      else if(json["treatment_country"] != null && (json["treatment_country"] != "")){
        treatmentCountry = json["treatment_country"];
      }
      isActive = json['is_active'];
      token = json['token'];
      id = json['id'];
      speciality = json['speciality'];
      biometric = json['local_auth' ];
    }catch(error, StackTrace){
      print(error);
      print(StackTrace);
    }

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
    data['id'] = id;
    data['biometric'] = biometric;
    return data;
  }
}


