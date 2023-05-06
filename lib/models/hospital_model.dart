class Hospital {
  int? id;
  String? name;
  String? address;
  String? description;
  String? logo;
  bool? isActive;

  Hospital(
      {this.id,
      this.name,
      this.address,
      this.description,
      this.logo,
      this.isActive});

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    logo = json['logo'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['description'] = description;
    data['logo'] = logo;
    data['is_active'] = isActive;
    return data;
  }
}