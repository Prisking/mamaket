class Delivery {
  String sId;
  String deliveryCompany;
  String deliveryContactName;
  String deliveryContactNumber;
  int price;
  String buyer;
  String product;
  String seller;

  Delivery(
      {this.sId,
      this.deliveryCompany,
      this.deliveryContactName,
      this.deliveryContactNumber,
      this.price,
      this.buyer,
      this.product,
      this.seller});

  Delivery.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    deliveryCompany = json['deliveryCompany'];
    deliveryContactName = json['deliveryContactName'];
    deliveryContactNumber = json['deliveryContactNumber'];
    price = json['price'];
    buyer = json['buyer'];
    product = json['product'];
    seller = json['seller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['deliveryCompany'] = this.deliveryCompany;
    data['deliveryContactName'] = this.deliveryContactName;
    data['deliveryContactNumber'] = this.deliveryContactNumber;
    data['price'] = this.price;
    data['buyer'] = this.buyer;
    data['product'] = this.product;
    data['seller'] = this.seller;
    return data;
  }
}
