class AddtoCartModel {
  int? status;
  String? message;
  Cart? cart;
  int? price;
  int? productQty;
  String? qty;

  AddtoCartModel(
      {this.status,
      this.message,
      this.cart,
      this.price,
      this.productQty,
      this.qty});

  AddtoCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cart = json['Cart'] != null ? Cart.fromJson(json['Cart']) : null;
    price = json['price'];
    productQty = json['product_qty'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (cart != null) {
      data['Cart'] = cart!.toJson();
    }
    data['price'] = price;
    data['product_qty'] = productQty;
    data['qty'] = qty;
    return data;
  }
}

class Cart {
  int? id;
  int? userId;
  int? productId;
  String? productQty;
  String? price;
  String? updatedAt;
  String? createdAt;

  Cart(
      {this.id,
      this.userId,
      this.productId,
      this.productQty,
      this.price,
      this.updatedAt,
      this.createdAt});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productQty = json['product_qty'];
    price = json['price'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['product_qty'] = productQty;
    data['price'] = price;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
