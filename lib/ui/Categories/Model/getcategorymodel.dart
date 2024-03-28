class GetCategoryModel {
  int? status;
  String? message;
  List<Data>? data;

  GetCategoryModel({this.status, this.message, this.data});

  GetCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? catId;
  String? catName;
  String? catImage;
  List<Product>? product;

  Data({this.catId, this.catName, this.catImage, this.product});

  Data.fromJson(Map<String, dynamic> json) {
    catId = json['CatId'];
    catName = json['CatName'];
    catImage = json['CatImage'];
    if (json['Product'] != null) {
      product = <Product>[];
      json['Product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CatId'] = catId;
    data['CatName'] = catName;
    data['CatImage'] = catImage;
    if (product != null) {
      data['Product'] = product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? productId;
  String? productName;
  int? catId;
  String? catName;

  Product({this.productId, this.productName, this.catId, this.catName});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    productName = json['ProductName'];
    catId = json['CatId'];
    catName = json['CatName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductId'] = productId;
    data['ProductName'] = productName;
    data['CatId'] = catId;
    data['CatName'] = catName;
    return data;
  }
}
