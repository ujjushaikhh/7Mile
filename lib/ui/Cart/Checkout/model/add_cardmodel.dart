class AddCardModel {
  int? status;
  String? message;
  Data? data;

  AddCardModel({this.status, this.message, this.data});

  AddCardModel.fromJson(Map<String, dynamic> json) {
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
  String? cardToken;

  Data({this.cardToken});

  Data.fromJson(Map<String, dynamic> json) {
    cardToken = json['card_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_token'] = cardToken;
    return data;
  }
}
