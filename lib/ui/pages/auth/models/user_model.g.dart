// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      role: fields[1] as String,
      name: fields[2] as String,
      phoneNumber: fields[3] as String,
      email: fields[4] as String,
      image: fields[5] as String,
      region: fields[6] as String,
      geometry: fields[9] as Geometry,
      bookmarkedProducts: (fields[7] as List)?.cast<String>(),
      accesstoken: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.region)
      ..writeByte(9)
      ..write(obj.geometry)
      ..writeByte(7)
      ..write(obj.bookmarkedProducts)
      ..writeByte(8)
      ..write(obj.accesstoken);
  }
}

class GeometryAdapter extends TypeAdapter<Geometry> {
  @override
  final typeId = 1;

  @override
  Geometry read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Geometry(
      type: fields[10] as String,
      coordinates: (fields[11] as List)?.cast<double>(),
      sId: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Geometry obj) {
    writer
      ..writeByte(3)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.coordinates)
      ..writeByte(12)
      ..write(obj.sId);
  }
}
