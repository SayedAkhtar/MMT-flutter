class ErrorResponse {
  String? status;
  String? message;
  String? error;

  ErrorResponse({this.status, this.message, this.error});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['STATUS'].toString();
    message = json['MESSAGE'];
    error = json.containsKey("ERROR")? json['ERROR'] : json['MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['STATUS'] = status;
    data['MESSAGE'] = message;
    data['ERROR'] = error;
    return data;
  }
}
