class Profile {
  String createdAt;
  String image;
  String sId;
  String name;
  String email;
  String phoneNumber;
  String role;
  String salt;
  Geometry geometry;
  String region;

  Profile(
      {this.createdAt,
      this.image,
      this.sId,
      this.name,
      this.email,
      this.phoneNumber,
      this.role,
      this.salt,
      this.geometry,
      this.region});

  Profile.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    image = json['image'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    salt = json['salt'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['role'] = this.role;
    data['salt'] = this.salt;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['region'] = this.region;
    return data;
  }
}

class Geometry {
  String type;
  List<double> coordinates;
  String sId;

  Geometry({this.type, this.coordinates, this.sId});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['_id'] = this.sId;
    return data;
  }
}
