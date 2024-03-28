class LoginModel {
  int? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  int? id;
  String? name;
  String? email;
  bool? isNotification;
  String? phone;
  String? image;
  String? deviceId;
  String? deviceType;

  Data(
      {this.token,
      this.id,
      this.name,
      this.email,
      this.isNotification,
      this.phone,
      this.image,
      this.deviceId,
      this.deviceType});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isNotification = json['is_notification'];
    phone = json['phone'];
    image = json['image'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['is_notification'] = isNotification;
    data['phone'] = phone;
    data['image'] = image;
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    return data;
  }
}
