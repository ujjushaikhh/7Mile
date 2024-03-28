class GetCartModel {
  int? status;
  String? message;
  Data? data;

  GetCartModel({this.status, this.message, this.data});

  GetCartModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  List<Products>? products;
  int? serviceCharge;
  int? totalPrice;

  Data(
      {this.id,
      this.orderId,
      this.products,
      this.serviceCharge,
      this.totalPrice});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    serviceCharge = json['service_charge'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['service_charge'] = serviceCharge;
    data['totalPrice'] = totalPrice;
    return data;
  }
}

class Products {
  int? cartDetailId;
  int? userId;
  int? productId;
  int? isCompleted;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? price;
  String? productQty;

  Products(
      {this.cartDetailId,
      this.userId,
      this.productId,
      this.isCompleted,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.name,
      this.price,
      this.productQty});

  Products.fromJson(Map<String, dynamic> json) {
    cartDetailId = json['cart_detail_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    isCompleted = json['is_completed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    productQty = json['product_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_detail_id'] = cartDetailId;
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['is_completed'] = isCompleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['name'] = name;
    data['price'] = price;
    data['product_qty'] = productQty;
    return data;
  }
}
