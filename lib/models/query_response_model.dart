class QueryResponse {
  int? nextStep;
  dynamic response;
  bool? paymentRequired;
  int? queryType;
  int? currentStep;
  int? queryId;
  List<int>? editableSteps;
  QueryResponse({this.nextStep, this.response, this.paymentRequired});

  QueryResponse.fromJson(Map<String, dynamic> json) {
    nextStep = json['next_step'];
    response = json['step_data'].isNotEmpty ? json['step_data'] : {};
    paymentRequired = json['payment_required'];
    queryType = json['type'];
    currentStep = json['current_step'];
    queryId = json['id'];
    List<int> temp = [];
    if(json['editable_steps']!=null && json['editable_steps'].isNotEmpty){
      json['editable_steps'].forEach((ele) => temp.add(int.parse(ele)));
    }
    editableSteps = temp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData["current_step"] = currentStep;
    formData["type"] = queryType;
    formData['response'] = response;
    formData['query_id'] = queryId;
    return formData;
  }
}
