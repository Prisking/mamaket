class City {
  int id;
  String trackingId;
  String name;

  City({this.id, this.trackingId, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingId = json['tracking_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tracking_id'] = this.trackingId;
    data['name'] = this.name;
    return data;
  }
}
