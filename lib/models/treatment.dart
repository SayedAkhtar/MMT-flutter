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
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? addedBy;
  int? updatedBy;

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
      this.notCovered,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.addedBy,
      this.updatedBy});

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
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addedBy = json['added_by'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['added_by'] = addedBy;
    data['updated_by'] = updatedBy;
    return data;
  }
}
