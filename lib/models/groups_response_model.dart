/*
import 'package:photos_app/models/user_model.dart';

class GroupsResponseModel {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  GroupsResponseModel({this.count, this.next, this.previous, this.results});

  GroupsResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? groupName;
  String? description;
  Null? groupPhoto;
  String? createdAt;
  String? updatedAt;
  AdminFk? adminFk;
  List<Null>? groupContent;
  List<UserModel>? members;
  int? membersCount;

  Results(
      {this.id,
      this.groupName,
      this.description,
      this.groupPhoto,
      this.createdAt,
      this.updatedAt,
      this.adminFk,
      this.groupContent,
      this.members,
      this.membersCount});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    description = json['description'];
    groupPhoto = json['group_photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminFk = json['admin_fk'] != null
        ? new AdminFk.fromJson(json['admin_fk'])
        : null;
    if (json['group_content'] != null) {
      groupContent = <Null>[];
      json['group_content'].forEach((v) {
        groupContent!.add(new Null.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    membersCount = json['members_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_name'] = this.groupName;
    data['description'] = this.description;
    data['group_photo'] = this.groupPhoto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.adminFk != null) {
      data['admin_fk'] = this.adminFk!.toJson();
    }
    if (this.groupContent != null) {
      data['group_content'] =
          this.groupContent!.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['members_count'] = this.membersCount;
    return data;
  }
}

class AdminFk {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  Null? country;
  String? photo;
  int? userType;
  String? phoneNumber;
  Null? age;
  String? city;
  String? createdAt;

  AdminFk(
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
      this.createdAt});

  AdminFk.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
*/
