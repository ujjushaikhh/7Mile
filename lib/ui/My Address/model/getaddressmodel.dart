class GetAddressModel {
  int? status;
  String? message;
  List<Address>? address;

  GetAddressModel({this.status, this.message, this.address});

  GetAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (address != null) {
      data['address'] = address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  int? userId;
  int? addressid;
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
  String? userPhone;

  Address(
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
      this.addressid,
      this.isDefault,
      this.userPhone});

  Address.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    houseNo = json['house_no'];
    landmark = json['landmark'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    addressid = json['id'];
    zipcode = json['zipcode'];
    isDefault = json['is_default'];
    userPhone = json['user_phone'];
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
    data['id'] = addressid;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['is_default'] = isDefault;
    data['user_phone'] = userPhone;
    return data;
  }
}
