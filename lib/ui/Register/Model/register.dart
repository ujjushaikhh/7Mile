class RegisterModel {
  int? status;
  String? message;
  Data? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? email;
  String? phone;
  bool? isNotification;
  String? image;

  Data(
      {this.token,
      this.name,
      this.email,
      this.phone,
      this.isNotification,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isNotification = json['is_notification'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['is_notification'] = isNotification;
    data['image'] = image;
    return data;
  }
}
