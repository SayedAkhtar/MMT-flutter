
class ConfirmedQuery {
  Accommodation? accommodation;
  Cab? cab;
  Coordinator? coordinator;

  ConfirmedQuery({this.accommodation, this.cab, this.coordinator});

  ConfirmedQuery.fromJson(Map<String, dynamic> json) {
    accommodation = json['accommodation'] != null
        ? new Accommodation.fromJson(json['accommodation'])
        : null;
    cab = json['cab'] != null ? new Cab.fromJson(json['cab']) : null;
    coordinator = json['coordinator'] != null
        ? new Coordinator.fromJson(json['coordinator'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accommodation != null) {
      data['accommodation'] = this.accommodation!.toJson();
    }
    if (this.cab != null) {
      data['cab'] = this.cab!.toJson();
    }
    if (this.coordinator != null) {
      data['coordinator'] = this.coordinator!.toJson();
    }
    return data;
  }
}

class Accommodation {
  String? name;
  String? address;
  String? geoLocation;

  Accommodation({this.name, this.address, this.geoLocation});

  Accommodation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    geoLocation = json['geo_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['geo_location'] = this.geoLocation;
    return data;
  }
}

class Cab {
  Null? name;
  Null? number;
  Null? type;

  Cab({this.name, this.number, this.type});

  Cab.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    data['type'] = this.type;
    return data;
  }
}

class Coordinator {
  String? name;
  String? phone;
  String? email;
  String? image;

  Coordinator({this.name, this.phone, this.email, this.image});

  Coordinator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}