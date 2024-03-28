class SearchAddModel {
  int? status;
  String? message;
  Search? search;

  SearchAddModel({this.status, this.message, this.search});

  SearchAddModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    search = json['search'] != null ? Search.fromJson(json['search']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (search != null) {
      data['search'] = search!.toJson();
    }
    return data;
  }
}

class Search {
  int? userId;
  int? productId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Search(
      {this.userId, this.productId, this.updatedAt, this.createdAt, this.id});

  Search.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    productId = json['product_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
