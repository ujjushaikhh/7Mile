class GetCardModel {
  int? status;
  String? message;
  List<GetCard>? data;

  GetCardModel({this.status, this.message, this.data});

  GetCardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetCard>[];
      json['data'].forEach((v) {
        data!.add(GetCard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetCard {
  String? cardId;
  String? cardName;
  int? cardExpiry;
  int? cardYear;
  String? cardNumber;
  String? cardBrand;

  GetCard(
      {this.cardId,
      this.cardName,
      this.cardExpiry,
      this.cardYear,
      this.cardNumber,
      this.cardBrand});

  GetCard.fromJson(Map<String, dynamic> json) {
    cardId = json['CardId'];
    cardName = json['CardName'];
    cardExpiry = json['CardExpiry'];
    cardYear = json['CardYear'];
    cardNumber = json['CardNumber'];
    cardBrand = json['CardBrand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CardId'] = cardId;
    data['CardName'] = cardName;
    data['CardExpiry'] = cardExpiry;
    data['CardYear'] = cardYear;
    data['CardNumber'] = cardNumber;
    data['CardBrand'] = cardBrand;
    return data;
  }
}
