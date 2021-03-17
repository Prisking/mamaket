import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String role;

  @HiveField(2)
  String name;

  @HiveField(3)
  String phoneNumber;

  @HiveField(4)
  String email;

  @HiveField(5)
  String image;

  @HiveField(6)
  String region;

  @HiveField(9)
  Geometry geometry;

  @HiveField(7)
  List<String> bookmarkedProducts;

  @HiveField(8)
  String accesstoken;

  User(
      {this.id,
      this.role,
      this.name,
      this.phoneNumber,
      this.email,
      this.image,
      this.region,
      this.geometry,
      this.bookmarkedProducts,
      this.accesstoken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    role = json['role'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    image = json['image'];
    region = json['region'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    bookmarkedProducts = json['bookmarkedProducts'].cast<String>();
    accesstoken = json['accesstoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['image'] = this.image;
    data['region'] = this.region;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['bookmarkedProducts'] = this.bookmarkedProducts;
    data['accesstoken'] = this.accesstoken;
    return data;
  }
}

@HiveType(typeId: 1)
class Geometry extends HiveObject {
  @HiveField(10)
  String type;

  @HiveField(11)
  List<double> coordinates;

  @HiveField(12)
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
