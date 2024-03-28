class GetSearchHistoryModel {
  int? status;
  String? message;
  List<SearchHistory>? search;

  GetSearchHistoryModel({this.status, this.message, this.search});

  GetSearchHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['search'] != null) {
      search = <SearchHistory>[];
      json['search'].forEach((v) {
        search!.add(SearchHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (search != null) {
      data['search'] = search!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchHistory {
  int? id;
  int? userId;
  int? productId;
  String? productName;

  SearchHistory({this.id, this.userId, this.productId, this.productName});

  SearchHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    return data;
  }
}
