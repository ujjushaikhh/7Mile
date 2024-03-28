class SearchModel {
  int? status;
  String? message;
  List<Products>? products;

  SearchModel({this.status, this.message, this.products});

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? catId;
  String? name;
  String? miniDescription;
  String? description;
  String? price;
  String? availableQty;
  String? createdAt;
  String? updatedAt;
  String? productImage;

  Products(
      {this.id,
      this.catId,
      this.name,
      this.miniDescription,
      this.description,
      this.price,
      this.availableQty,
      this.createdAt,
      this.updatedAt,
      this.productImage});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['cat_id'];
    name = json['name'];
    miniDescription = json['mini_description'];
    description = json['description'];
    price = json['price'];
    availableQty = json['available_qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cat_id'] = catId;
    data['name'] = name;
    data['mini_description'] = miniDescription;
    data['description'] = description;
    data['price'] = price;
    data['available_qty'] = availableQty;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_image'] = productImage;
    return data;
  }
}
