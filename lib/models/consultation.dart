class Consultation {
  Consultation({
    required this.id,
    required this.channelName,
    required this.doctorId,
    required this.patientId,
    required this.scheduledAt,
    this.messages,
    required this.isActive,
    required this.isCompleted,
    required this.paymentId,
    required this.paymentStatus,
    required this.doctorName,
    required this.agoraId,
  });
  late final int id;
  late final String channelName;
  late final int doctorId;
  late final int patientId;
  late final String scheduledAt;
  late final Null messages;
  late final bool isActive;
  late final bool isCompleted;
  late final int paymentId;
  late final String paymentStatus;
  late final String createdAt;
  late final String updatedAt;
  late final String doctorName;
  late final String agoraId;

  Consultation.fromJson(Map<String, dynamic> json){
    id = json['id'];
    channelName = json['channel_name'];
    doctorId = json['doctor_id'];
    patientId = json['patient_id'];
    scheduledAt = json['scheduled_at'];
    messages = null;
    isActive = json['is_active'];
    isCompleted = json['is_completed'];
    paymentId = json['payment_id'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctorName = json['doctor_name'];
    agoraId = json['agora_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['channel_name'] = channelName;
    _data['doctor_id'] = doctorId;
    _data['patient_id'] = patientId;
    _data['scheduled_at'] = scheduledAt;
    _data['messages'] = messages;
    _data['is_active'] = isActive;
    _data['is_completed'] = isCompleted;
    _data['payment_id'] = paymentId;
    _data['payment_status'] = paymentStatus;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['doctor_name'] = doctorName;
    _data['agora_id'] = agoraId;
    return _data;
  }
}