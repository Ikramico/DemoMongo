// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  Model({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
  });

  ObjectId id;
  String name;
  String email;
  String about;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "about": about,
      };
}
