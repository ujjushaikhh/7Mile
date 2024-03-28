class CheckOutModel {
  int? status;
  String? message;
  int? id;
  String? charge;
  String? transactionId;
  String? type;

  CheckOutModel(
      {this.status,
      this.message,
      this.id,
      this.charge,
      this.transactionId,
      this.type});

  CheckOutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
    charge = json['charge'];
    transactionId = json['transaction_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['id'] = id;
    data['charge'] = charge;
    data['transaction_id'] = transactionId;
    data['type'] = type;
    return data;
  }
}
