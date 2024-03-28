class HomeModel {
  int? status;
  String? message;
  Data? data;

  HomeModel({this.status, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
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
  List<Deal>? deal;
  List<Category>? category;
  List<NewArivals>? newArivals;
  List<BestSeller>? bestSeller;
  List<HotTrending>? hotTrending;

  Data(
      {this.deal,
      this.category,
      this.newArivals,
      this.bestSeller,
      this.hotTrending});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['deal'] != null) {
      deal = <Deal>[];
      json['deal'].forEach((v) {
        deal!.add(Deal.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    if (json['new_arivals'] != null) {
      newArivals = <NewArivals>[];
      json['new_arivals'].forEach((v) {
        newArivals!.add(NewArivals.fromJson(v));
      });
    }
    if (json['best_seller'] != null) {
      bestSeller = <BestSeller>[];
      json['best_seller'].forEach((v) {
        bestSeller!.add(BestSeller.fromJson(v));
      });
    }
    if (json['hot_trending'] != null) {
      hotTrending = <HotTrending>[];
      json['hot_trending'].forEach((v) {
        hotTrending!.add(HotTrending.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deal != null) {
      data['deal'] = deal!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    if (newArivals != null) {
      data['new_arivals'] = newArivals!.map((v) => v.toJson()).toList();
    }
    if (bestSeller != null) {
      data['best_seller'] = bestSeller!.map((v) => v.toJson()).toList();
    }
    if (hotTrending != null) {
      data['hot_trending'] = hotTrending!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deal {
  int? id;
  String? name;
  String? discount;
  String? description;
  String? image;

  Deal({this.id, this.name, this.discount, this.description, this.image});

  Deal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    discount = json['discount'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['discount'] = discount;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;

  Category({this.id, this.name, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class NewArivals {
  int? id;
  String? name;
  String? price;
  String? image;
  String? avgRating;
  bool? isLiked;

  NewArivals(
      {this.id,
      this.name,
      this.price,
      this.image,
      this.avgRating,
      this.isLiked});

  NewArivals.fromJson(Map<String, dynamic> json) {
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

class HotTrending {
  int? id;
  String? name;
  String? price;
  String? image;
  String? avgRating;
  bool? isLiked;

  HotTrending(
      {this.id,
      this.name,
      this.price,
      this.image,
      this.avgRating,
      this.isLiked});

  HotTrending.fromJson(Map<String, dynamic> json) {
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
