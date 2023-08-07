class QueryResponse {
  int? nextStep;
  Map<String, dynamic>? response;
  bool? paymentRequired;
  int? queryType;
  int? currentStep;
  int? queryId;
  QueryResponse({this.nextStep, this.response, this.paymentRequired});

  QueryResponse.fromJson(Map<String, dynamic> json) {
    nextStep = json['next_step'];
    response = json['step_data'].isNotEmpty ? json['step_data'] : {};
    paymentRequired = json['payment_required'];
    queryType = json['type'];
    currentStep = json['current_step'];
    queryId = json['id'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['question'] = this.question;
  //   data['answer'] = this.answer;
  //   return data;
  // }
}
