import 'dart:convert';

import '../../domain/entities/user.dart';

class UserModel extends User{

  UserModel({
    required String id,
    required String name,
    required String email,
  }):super(
    id: id,
    name: name,
    email: email,
  );


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']??json['userId']??json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email}';
  }
  // from string to UserModel
  factory UserModel.fromString(String source) {
    final json = jsonDecode(source);
    return UserModel.fromJson(json);
  }
}
