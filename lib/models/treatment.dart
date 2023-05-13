class Treatment {
  int? id;
  String? name;
  int? price;
  List<String>? images;
  int? daysRequired;
  int? recoveryTime;
  int? successRate;
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
        this.price,
        this.images,
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
    price = json['price'];
    // if (json['images'] != null) {
    //   images = <String>[];
    //   json['images'].forEach((v) {
    //     images!.add(v);
    //   });
    // }
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
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    if (this.images != null) {
      data['images'] = this.images!.toList();
    }
    data['days_required'] = this.daysRequired;
    data['recovery_time'] = this.recoveryTime;
    data['success_rate'] = this.successRate;
    data['covered'] = this.covered;
    data['not_covered'] = this.notCovered;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['added_by'] = this.addedBy;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
