class MyOrderModel {
  int? status;
  String? message;
  List<Cart>? cart;

  MyOrderModel({this.status, this.message, this.cart});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart!.add(Cart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart {
  int? cartId;
  int? addressId;
  String? houseNo;
  String? landmark;
  String? address;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  String? zipcode;
  List<Products>? products;

  Cart(
      {this.cartId,
      this.addressId,
      this.houseNo,
      this.landmark,
      this.address,
      this.latitude,
      this.longitude,
      this.city,
      this.state,
      this.zipcode,
      this.products});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    addressId = json['address_id'];
    houseNo = json['house_no'];
    landmark = json['landmark'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['address_id'] = addressId;
    data['house_no'] = houseNo;
    data['landmark'] = landmark;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? cartDetailsId;
  int? isRate;
  String? rmdOrderId;
  int? isCancel;
  int? orderStatus;
  String? productQty;
  int? productId;
  String? name;
  String? price;
  String? image;

  Products(
      {this.cartDetailsId,
      this.isRate,
      this.rmdOrderId,
      this.isCancel,
      this.orderStatus,
      this.productQty,
      this.productId,
      this.name,
      this.price,
      this.image});

  Products.fromJson(Map<String, dynamic> json) {
    cartDetailsId = json['cart_details_id'];
    isRate = json['isRate'];
    rmdOrderId = json['rmd_order_id'];
    isCancel = json['is_cancel'];
    orderStatus = json['order_status'];
    productQty = json['product_qty'];
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_details_id'] = cartDetailsId;
    data['isRate'] = isRate;
    data['rmd_order_id'] = rmdOrderId;
    data['is_cancel'] = isCancel;
    data['order_status'] = orderStatus;
    data['product_qty'] = productQty;
    data['product_id'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}
