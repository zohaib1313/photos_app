import 'package:photos_app/dio_networking/decodable.dart';

class UserModel implements Decodeable {
  String? token;
  int? id;
  String? username;
  String? email;
  String? created;
  bool? isAdmin;
  String? firstName;
  int? userType;
  String? photo;

  UserModel(
      {this.token,
      this.id,
      this.username,
      this.email,
      this.created,
      this.isAdmin,
      this.firstName,
      this.userType,
      this.photo});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    created = json['created'];
    isAdmin = json['is_admin'];
    firstName = json['first_name'];
    userType = json['user_type'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['created'] = this.created;
    data['is_admin'] = this.isAdmin;
    data['first_name'] = this.firstName;
    data['user_type'] = this.userType;
    data['photo'] = this.photo;
    return data;
  }

  @override
  decode(json) {
    token = json['token'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    created = json['created'];
    isAdmin = json['is_admin'];
    firstName = json['first_name'];
    userType = json['user_type'];
    photo = json['photo'];
    return this;
  }
}
