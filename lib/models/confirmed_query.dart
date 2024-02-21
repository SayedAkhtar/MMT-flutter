
class ConfirmedQuery {
  Accommodation? accommodation;
  Cab? cab;
  Coordinator? coordinator;
  List<Status>? statuses;
  ConfirmedQuery({this.accommodation, this.cab, this.coordinator, this.statuses});

  ConfirmedQuery.fromJson(Map<String, dynamic> json) {
    accommodation = json['accommodation'] != null
        ? Accommodation.fromJson(json['accommodation'])
        : null;
    cab = json['cab'] != null ? Cab.fromJson(json['cab']) : null;
    coordinator = json['coordinator'] != null
        ? Coordinator.fromJson(json['coordinator'])
        : null;
    List<Status> tempStatus = [];
    if(json['status'] != null){
      json['status'].forEach((element){
        Status t = Status.fromJson(element);
        tempStatus.add(t);
      });
    }
    statuses = tempStatus;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (accommodation != null) {
      data['accommodation'] = accommodation!.toJson();
    }
    if (cab != null) {
      data['cab'] = cab!.toJson();
    }
    if (coordinator != null) {
      data['coordinator'] = coordinator!.toJson();
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
    name = json['name'] ?? "";
    address = json['address'] ?? "";
    geoLocation = json['geo_location'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['geo_location'] = geoLocation;
    return data;
  }
}

class Cab {
  String? name;
  String? number;
  String? type;

  Cab({this.name, this.number, this.type});

  Cab.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    number = json['car_number'] ?? "";
    type = json['car_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    data['type'] = type;
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
    email = json['email'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}

class Status {
  String? status;
  List<String>? file;
  int? timestamp;

  Status({this.status, this.file, this.timestamp});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    file = json['file'] != null ?json['file'].cast<String>() :[];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['file'] = file;
    data['timestamp'] = timestamp;
    return data;
  }
}