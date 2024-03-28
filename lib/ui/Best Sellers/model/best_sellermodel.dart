class BestSellers {
  int? status;
  String? message;
  Data? data;

  BestSellers({this.status, this.message, this.data});

  BestSellers.fromJson(Map<String, dynamic> json) {
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
  List<BestSeller>? bestSeller;

  Data({this.bestSeller});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['best_seller'] != null) {
      bestSeller = <BestSeller>[];
      json['best_seller'].forEach((v) {
        bestSeller!.add(BestSeller.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bestSeller != null) {
      data['best_seller'] = bestSeller!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BestSeller {
  int? id;
  String? name;
  String? price;
  String? image;
  String? avgRating;
  bool? isLiked;

  BestSeller(
      {this.id,
      this.name,
      this.price,
      this.image,
      this.avgRating,
      this.isLiked});

  BestSeller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    avgRating = json['avg_rating'];
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['avg_rating'] = avgRating;
    data['is_liked'] = isLiked;
    return data;
  }
}
