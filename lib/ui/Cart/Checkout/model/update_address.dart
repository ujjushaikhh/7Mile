class UpdateAddressModel {
  int? status;
  String? message;
  Data? data;

  UpdateAddressModel({this.status, this.message, this.data});

  UpdateAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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
  String? createdAt;
  String? updatedAt;

  Data(
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
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
