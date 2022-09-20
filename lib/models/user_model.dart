import 'package:photos_app/dio_networking/decodable.dart';

class UserModel implements Decodeable {
  String? token;
  int? id;
  String? username;
  String? email;
  String? created;
  String? age;
  String? phoneNumber;
  bool? isAdmin;
  String? firstName;
  String? lastName;
  String? country;
  String? city;
  int? userType;
  String? photo;

  UserModel(
      {this.token,
      this.id,
      this.username,
      this.email,
      this.created,
      this.age,
      this.phoneNumber,
      this.isAdmin,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.userType,
      this.photo});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    created = json['created'];
    age = json['age'].toString();
    phoneNumber = json['phone_number'];
    isAdmin = json['is_admin'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    country = json['country'];
    city = json['city'];
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
    data['age'] = this.age;
    data['phone_number'] = this.phoneNumber;
    data['is_admin'] = this.isAdmin;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['country'] = this.country;
    data['city'] = this.city;
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
    age = json['age'].toString();
    phoneNumber = json['phone_number'];
    isAdmin = json['is_admin'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    country = json['country'];
    city = json['city'];
    userType = json['user_type'];
    photo = json['photo'];
    return this;
  }
}
