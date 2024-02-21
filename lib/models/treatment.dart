class Treatment {
  int? id;
  String? name;
  int? minPrice;
  int? maxPrice;
  String? logo;
  String? daysRequired;
  String? recoveryTime;
  String? successRate;
  String? covered;
  String? notCovered;

  Treatment(
      {this.id,
      this.name,
      this.minPrice,
      this.maxPrice,
      this.logo,
      this.daysRequired,
      this.recoveryTime,
      this.successRate,
      this.covered,
      this.notCovered});

  Treatment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    logo = json['logo'];
    daysRequired = json['days_required'];
    recoveryTime = json['recovery_time'];
    successRate = json['success_rate'];
    covered = json['covered'];
    notCovered = json['not_covered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['min_price'] = minPrice;
    data['max_price'] = maxPrice;
    data['logo'] = logo;
    data['days_required'] = daysRequired;
    data['recovery_time'] = recoveryTime;
    data['success_rate'] = successRate;
    data['covered'] = covered;
    data['not_covered'] = notCovered;
    return data;
  }
}
