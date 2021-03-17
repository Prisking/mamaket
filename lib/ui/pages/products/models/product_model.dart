class Product {
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
  String sellerId;
  String productSaleType;

  Product({
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

  Product.fromJson(Map<String, dynamic> json) {
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
    sellerId = json['sellerId'];
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
    data['sellerId'] = this.sellerId;
    data['productSaleType'] = this.productSaleType;

    return data;
  }
}
