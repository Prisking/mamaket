class PopulatedProduct {
  List<String> images;
  List<String> tags;
  String sponsored;
  String createdAt;
  String updatedAt;
  int views;
  int reviewCount;
  String sId;
  String name;
  String description;
  int price;
  String categoryId;
  int quantity;
  bool negotiable;
  String sellerName;
  SellerId sellerId;
  String productSaleType;

  PopulatedProduct({
    this.images,
    this.tags,
    this.sponsored,
    this.createdAt,
    this.updatedAt,
    this.views,
    this.reviewCount,
    this.sId,
    this.name,
    this.description,
    this.price,
    this.categoryId,
    this.quantity,
    this.negotiable,
    this.sellerName,
    this.sellerId,
    this.productSaleType,
  });

  PopulatedProduct.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    tags = json['tags'].cast<String>();
    sponsored = json['sponsored'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    views = json['views'];
    reviewCount = json['reviewCount'];
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    categoryId = json['categoryId'];
    quantity = json['quantity'];
    negotiable = json['negotiable'];
    sellerName = json['sellerName'];
    sellerId = json['sellerId'] != null
        ? new SellerId.fromJson(json['sellerId'])
        : null;
    productSaleType = json['productSaleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['tags'] = this.tags;
    data['sponsored'] = this.sponsored;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['views'] = this.views;
    data['reviewCount'] = this.reviewCount;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['categoryId'] = this.categoryId;
    data['quantity'] = this.quantity;
    data['negotiable'] = this.negotiable;
    data['sellerName'] = this.sellerName;
    if (this.sellerId != null) {
      data['sellerId'] = this.sellerId.toJson();
    }
    data['productSaleType'] = this.productSaleType;
    return data;
  }
}

class SellerId {
  String sId;
  String name;
  String region;
  String phoneNumber;

  SellerId({this.sId, this.name});

  SellerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    region = json['region'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['region'] = this.region;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
