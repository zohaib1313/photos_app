import 'package:photos_app/dio_networking/decodable.dart';

class UserModel implements Decodeable {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? country;
  String? photo;
  int? userType;
  String? phoneNumber;
  String? token;
  String? fullName;
  String? city;
  String? createdAt;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.address,
      this.country,
      this.photo,
      this.userType,
      this.phoneNumber,
      this.token,
      this.fullName,
      this.city,
      this.createdAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    country = json['country'];
    photo = json['photo'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    token = json['token'];
    fullName = json['full_name'];
    city = json['city'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['country'] = this.country;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['token'] = this.token;
    data['full_name'] = this.fullName;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    country = json['country'];
    photo = json['photo'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    token = json['token'];
    fullName = json['full_name'];
    city = json['city'];
    createdAt = json['created_at'];
    return this;
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, address: $address, country: $country, photo: $photo, userType: $userType, phoneNumber: $phoneNumber, token: $token, fullName: $fullName, city: $city, createdAt: $createdAt}';
  }
}
