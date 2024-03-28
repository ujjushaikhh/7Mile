class AddressDetail {
  int? status;
  String? message;
  AddressDefault? address;

  AddressDetail({this.status, this.message, this.address});

  AddressDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    address = json['address'] != null
        ? AddressDefault.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class AddressDefault {
  int? userId;
  String? name;
  String? houseNo;
  String? landmark;
  String? address;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  String? zipcode;
  int? isDefault;

  AddressDefault(
      {this.userId,
      this.name,
      this.houseNo,
      this.landmark,
      this.address,
      this.latitude,
      this.longitude,
      this.city,
      this.state,
      this.zipcode,
      this.isDefault});

  AddressDefault.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    houseNo = json['house_no'];
    landmark = json['landmark'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['house_no'] = houseNo;
    data['landmark'] = landmark;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['is_default'] = isDefault;
    return data;
  }
}
