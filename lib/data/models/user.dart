import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(
  tableName: "users",
)
class User {
  @primaryKey
  int id;
  String name;
  String email;
  String phone;
  String photo;
  String token;
  String tokenType;
  String role;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.role,
    this.token,
    this.tokenType,
  });

  //format from json/map to object
  factory User.formJson({
    @required dynamic userJSONObject,
    bool withRoles = true,
  }) {
    final user = User();
    user.id = userJSONObject["id"];
    user.name = userJSONObject["name"];
    user.email = userJSONObject["email"];
    user.phone = (userJSONObject["phone"] ?? "").toString();
    user.photo = userJSONObject["photo"] ?? "";
    //roles
    if (withRoles) {
      final roles = userJSONObject["roles"] as List;
      user.role = roles.length > 0 ? userJSONObject["roles"][0]["name"] : "all";
    }
    return user;
  }
}
