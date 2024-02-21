class Faq {
  String? question;
  String? answer;

  Faq({this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
