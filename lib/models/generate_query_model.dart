class GenerateQuery {
  final int patientId;
  final int specializationId;
  final int hospitalId;
  int? doctorId;
  final String preferredCountry;
  final String medicalHistory;
  String? passportImage;
  String? status;

  GenerateQuery({
    required this.patientId,
    required this.specializationId,
    required this.hospitalId,
    required this.preferredCountry,
    required this.medicalHistory,
    this.doctorId,
    this.passportImage,
    this.status
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['specialization_id'] = specializationId;
    data['hospital_id'] = hospitalId;
    data['preferred_country'] = preferredCountry;
    data['doctor_id'] = doctorId;
    data['passport_image'] = passportImage;
    data['status'] = status??"active";
    return data;
  }
}
