import 'package:MyMedTrip/helper/Utils.dart';

import '../constants/query_type.dart';

class QueryScreen {
  List<ActiveQuery>? activeQuery;
  List<AllQuery>? allQuery;

  QueryScreen({this.activeQuery, this.allQuery});

  QueryScreen.fromJson(Map<String, dynamic> json) {
    if (json['active_query'] != null) {
      activeQuery = <ActiveQuery>[];
      json['active_query'].forEach((v) {
        if(v['doctor_response'] != null){
          activeQuery?.add(ActiveQuery.fromJson(v));
        }
      });
    }
    if (json['all_query'] != null) {
      allQuery = <AllQuery>[];
      json['all_query'].forEach((v) {
        allQuery?.add(AllQuery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (activeQuery != null) {
      data['active_query'] = activeQuery?.map((v) => v.toJson()).toList();
    }
    if (allQuery != null) {
      data['all_query'] = allQuery?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActiveQuery {
  int? id;
  String? queryHash;
  String? name;
  String? specialization;
  String? doctorResponse;
  String? stepName;
  String? stepNote;
  bool? isPaymentRequired;
  bool? isPaymentDone;
  bool? isConfirmed;
  int? currentStep;
  int? nextStep;
  int? type;
  String? createdAt;

  ActiveQuery(
      {this.id,
        this.queryHash,
      this.name,
      this.specialization,
      this.doctorResponse,
      this.stepName,
      this.stepNote,
      this.isPaymentRequired,
      this.isPaymentDone,
        this.isConfirmed,
      this.currentStep,
        this.type,
      this.createdAt});

  ActiveQuery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    queryHash = json['query_hash'];
    name = json['name'] ?? '';
    specialization = json['specialization'];
    doctorResponse = json['doctor_response'];
    stepName = json['query_step_name'];
    stepNote = json['query_step_note'];
    isPaymentRequired = json['payment_required'];
    isPaymentDone = json['is_payment_done'];
    isConfirmed = json['is_confirmed'];
    currentStep = json['current_step'];
    nextStep = json['next_step'];
    createdAt = Utils.localDateTimeFromTimestamp(json['created_at']);
    type = json['type'] == 2? QueryType.medicalVisa : QueryType.query;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['specialization'] = specialization;
    data['doctor_response'] = doctorResponse;
    data['is_payment_required'] = isPaymentRequired;
    data['is_payment_done'] = isPaymentDone;
    // data['created_at'] = createdAt;
    data['current_step'] = currentStep;
    return data;
  }
}

class AllQuery {
  int? id;
  String? name;
  String? specialization;
  String? createdAt;
  bool? isCompleted;
  String? completedAt;

  AllQuery(
      {this.id,
      this.name,
      this.specialization,
      this.createdAt,
      this.isCompleted,
      this.completedAt});

  AllQuery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    specialization = json['specialization'];
    createdAt = json['created_at'];
    isCompleted = json['is_completed'];
    completedAt = json['completed_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['specialization'] = specialization;
    data['created_at'] = createdAt;
    data['is_completed'] = isCompleted;
    data['completed_at'] = completedAt;
    return data;
  }
}
