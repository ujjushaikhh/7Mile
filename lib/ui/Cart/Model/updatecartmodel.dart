class UpdateQtyModel {
  int? status;
  String? message;
  Data? data;

  UpdateQtyModel({this.status, this.message, this.data});

  UpdateQtyModel.fromJson(Map<String, dynamic> json) {
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
  int? cartId;
  int? isRate;
  int? productId;
  String? productQty;
  String? price;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.cartId,
      this.isRate,
      this.productId,
      this.productQty,
      this.price,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    isRate = json['isRate'];
    productId = json['product_id'];
    productQty = json['product_qty'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_id'] = cartId;
    data['isRate'] = isRate;
    data['product_id'] = productId;
    data['product_qty'] = productQty;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
