import 'package:photos_app/dio_networking/decodable.dart';
import 'package:photos_app/models/user_model.dart';

class SearchFriendUserResponseModel implements Decodeable {
  int? userId;
  SearchedFriendUserModel? searchedUser;
  String? status;

  SearchFriendUserResponseModel({this.userId, this.searchedUser, this.status});

  SearchFriendUserResponseModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    searchedUser = json['friend'] != null
        ? new SearchedFriendUserModel.fromJson(json['friend'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    if (this.searchedUser != null) {
      data['friend'] = this.searchedUser!.toJson();
    }
    data['status'] = this.status;
    return data;
  }

  @override
  decode(json) {
    userId = json['user_id'];
    searchedUser = json['friend'] != null
        ? new SearchedFriendUserModel.fromJson(json['friend'])
        : null;
    status = json['status'];
    return this;
  }
}

class SearchedFriendUserModel {
  int? id;
  String? username;
  String? photo;
  String? firstName;
  String? lastName;

  SearchedFriendUserModel(
      {this.id, this.username, this.photo, this.firstName, this.lastName});

  SearchedFriendUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    photo = json['photo'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['photo'] = this.photo;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
