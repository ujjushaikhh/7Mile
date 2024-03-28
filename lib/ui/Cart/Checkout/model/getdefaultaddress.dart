class GetdefaultAddessModel {
  int? status;
  String? message;
  Addresses? addresses;

  GetdefaultAddessModel({this.status, this.message, this.addresses});

  GetdefaultAddessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    addresses = json['addresses'] != null
        ? Addresses.fromJson(json['addresses'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (addresses != null) {
      data['addresses'] = addresses!.toJson();
    }
    return data;
  }
}

class Addresses {
  int? id;
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
  String? userPhone;

  Addresses(
      {this.id,
      this.userId,
      this.name,
      this.houseNo,
      this.landmark,
      this.address,
      this.latitude,
      this.longitude,
      this.city,
      this.state,
      this.zipcode,
      this.isDefault,
      this.userPhone});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
    data['user_phone'] = userPhone;
    return data;
  }
}
