import 'package:photos_app/dio_networking/decodable.dart';

class FriendsListModelResponse implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<FriendsModel>? friendsList;

  FriendsListModelResponse(
      {this.count, this.next, this.previous, this.friendsList});

  FriendsListModelResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      friendsList = <FriendsModel>[];
      json['results'].forEach((v) {
        friendsList!.add(new FriendsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.friendsList != null) {
      data['results'] = this.friendsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      friendsList = <FriendsModel>[];
      json['results'].forEach((v) {
        friendsList!.add(new FriendsModel.fromJson(v));
      });
    }
    return this;
  }
}

class FriendsModel implements Decodeable {
  int? id;
  int? userFk;
  FriendFk? friendFk;
  String? friendRequestStatus;

  FriendsModel({this.id, this.userFk, this.friendFk, this.friendRequestStatus});

  FriendsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFk = json['user_fk'];
    friendFk = json['friend_fk'] != null
        ? new FriendFk.fromJson(json['friend_fk'])
        : null;
    friendRequestStatus = json['friend_request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_fk'] = this.userFk;
    if (this.friendFk != null) {
      data['friend_fk'] = this.friendFk!.toJson();
    }
    data['friend_request_status'] = this.friendRequestStatus;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    userFk = json['user_fk'];
    friendFk = json['friend_fk'] != null
        ? new FriendFk.fromJson(json['friend_fk'])
        : null;
    friendRequestStatus = json['friend_request_status'];
    return this;
  }
}

class FriendFk {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? country;
  Null? photo;
  int? userType;
  String? phoneNumber;
  int? age;
  String? city;
  String? createdAt;
  bool? isInvited;

  FriendFk(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.country,
      this.photo,
      this.userType,
      this.phoneNumber,
      this.age,
      this.city,
      this.createdAt,
      this.isInvited});

  FriendFk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    country = json['country'];
    photo = json['photo'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    age = json['age'];
    city = json['city'];
    createdAt = json['created_at'];
    isInvited = json['is_invited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['country'] = this.country;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['age'] = this.age;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    data['is_invited'] = this.isInvited;
    return data;
  }
}
