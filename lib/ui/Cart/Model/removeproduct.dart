class RemoveProductModel {
  int? status;
  String? message;
  int? cartId;

  RemoveProductModel({this.status, this.message, this.cartId});

  RemoveProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cartId = json['cart_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['cart_id'] = cartId;
    return data;
  }
}
