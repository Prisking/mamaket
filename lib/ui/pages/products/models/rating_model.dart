class Rating {
  String nId;
  double avgRating;
  int numRating;

  Rating({this.nId, this.avgRating, this.numRating});

  Rating.fromJson(Map<String, dynamic> json) {
    nId = json['_id'];
    avgRating = changeToDouble(json['avgRating']);
    numRating = json['numRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.nId;
    data['avgRating'] = this.avgRating;
    data['numRating'] = this.numRating;
    return data;
  }

  double changeToDouble(number) {
    return number.toDouble();
  }
}

class IsRated {
  String sId;
  int rating;
  String sellerId;
  String userId;

  IsRated({this.sId, this.rating, this.sellerId, this.userId});

  IsRated.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rating = json['rating'];
    sellerId = json['sellerId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rating'] = this.rating;
    data['sellerId'] = this.sellerId;
    data['userId'] = this.userId;
    return data;
  }
}
