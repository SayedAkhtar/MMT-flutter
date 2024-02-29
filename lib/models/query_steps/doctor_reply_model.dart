class DoctorReplyModel {
  String description = "";
  String proformaInvoice = "";
  bool documentRequired = false;
  String? patient;
  DoctorReplyModel({required this.description, required this.proformaInvoice, required this.documentRequired, this.patient});

  DoctorReplyModel.fromJson(Map<String, dynamic> json) {
    description = json['doctor'];
    proformaInvoice = json['proforma_invoice'] ?? "";
    documentRequired = json['document_required'];
    patient = json['patient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = <String, dynamic>{};
    formData["doctor"] = description;
    formData["proforma_invoice"] = proformaInvoice;
    formData['document_required'] = documentRequired;
    formData['patient'] = patient;
    return formData;
  }
}
