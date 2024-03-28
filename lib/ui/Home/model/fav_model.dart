class FavouriteModel {
  int? status;
  String? message;
  Favorite? favorite;

  FavouriteModel({this.status, this.message, this.favorite});

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    favorite =
        json['favorite'] != null ? Favorite.fromJson(json['favorite']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (favorite != null) {
      data['favorite'] = favorite!.toJson();
    }
    return data;
  }
}

class Favorite {
  int? userId;
  int? productId;
  int? isLike;

  Favorite({this.userId, this.productId, this.isLike});

  Favorite.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    productId = json['product_id'];
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['is_like'] = isLike;
    return data;
  }
}
