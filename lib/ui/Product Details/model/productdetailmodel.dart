class GetProductDetailModel {
  int? status;
  String? message;
  ProductsData? productsData;

  GetProductDetailModel({this.status, this.message, this.productsData});

  GetProductDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    productsData = json['products_data'] != null
        ? ProductsData.fromJson(json['products_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (productsData != null) {
      data['products_data'] = productsData!.toJson();
    }
    return data;
  }
}

class ProductsData {
  int? id;
  int? catId;
  String? catName;
  String? name;
  String? miniDescription;
  String? description;
  String? price;
  String? availableQty;
  bool? isLiked;
  List<ProductImages>? productImages;
  List<ProductSpecifications>? productSpecifications;
  List<ProductRatings>? productRatings;
  String? averageRate;

  ProductsData(
      {this.id,
      this.catId,
      this.catName,
      this.name,
      this.miniDescription,
      this.description,
      this.price,
      this.availableQty,
      this.isLiked,
      this.productImages,
      this.productSpecifications,
      this.productRatings,
      this.averageRate});

  ProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['cat_id'];
    catName = json['cat_name'];
    name = json['name'];
    miniDescription = json['mini_description'];
    description = json['description'];
    price = json['price'];
    availableQty = json['available_qty'];
    isLiked = json['is_liked'];
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
    if (json['product_specifications'] != null) {
      productSpecifications = <ProductSpecifications>[];
      json['product_specifications'].forEach((v) {
        productSpecifications!.add(ProductSpecifications.fromJson(v));
      });
    }
    if (json['product_ratings'] != null) {
      productRatings = <ProductRatings>[];
      json['product_ratings'].forEach((v) {
        productRatings!.add(ProductRatings.fromJson(v));
      });
    }
    averageRate = json['average_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cat_id'] = catId;
    data['cat_name'] = catName;
    data['name'] = name;
    data['mini_description'] = miniDescription;
    data['description'] = description;
    data['price'] = price;
    data['available_qty'] = availableQty;
    data['is_liked'] = isLiked;
    if (productImages != null) {
      data['product_images'] = productImages!.map((v) => v.toJson()).toList();
    }
    if (productSpecifications != null) {
      data['product_specifications'] =
          productSpecifications!.map((v) => v.toJson()).toList();
    }
    if (productRatings != null) {
      data['product_ratings'] = productRatings!.map((v) => v.toJson()).toList();
    }
    data['average_rate'] = averageRate;
    return data;
  }
}

class ProductImages {
  int? id;
  int? productId;
  String? image;

  ProductImages({this.id, this.productId, this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['image'] = image;
    return data;
  }
}

class ProductSpecifications {
  int? id;
  int? productId;
  String? title;
  String? subTitle;

  ProductSpecifications({this.id, this.productId, this.title, this.subTitle});

  ProductSpecifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'];
    subTitle = json['sub_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['title'] = title;
    data['sub_title'] = subTitle;
    return data;
  }
}

class ProductRatings {
  int? id;
  int? userId;
  String? userName;
  String? userImage;
  int? productId;
  String? rate;
  String? review;
  String? createdAt;

  ProductRatings(
      {this.id,
      this.userId,
      this.userName,
      this.userImage,
      this.productId,
      this.rate,
      this.review,
      this.createdAt});

  ProductRatings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    productId = json['product_id'];
    rate = json['rate'];
    review = json['review'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    data['product_id'] = productId;
    data['rate'] = rate;
    data['review'] = review;
    data['created_at'] = createdAt;
    return data;
  }
}
