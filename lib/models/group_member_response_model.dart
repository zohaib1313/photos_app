import 'package:photos_app/dio_networking/decodable.dart';

class GroupMemberSearchResponseModel implements Decodeable {
  int? groupId;
  GroupMemberModel? member;
  bool? status;

  GroupMemberSearchResponseModel({this.groupId, this.member, this.status});

  GroupMemberSearchResponseModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    member = json['member'] != null
        ? new GroupMemberModel.fromJson(json['member'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    data['status'] = this.status;
    return data;
  }

  @override
  decode(json) {
    groupId = json['group_id'];
    member = json['member'] != null
        ? new GroupMemberModel.fromJson(json['member'])
        : null;
    status = json['status'];
    return this;
  }
}

class GroupMemberModel {
  int? id;
  String? username;
  String? photo;
  String? firstName;
  String? lastName;

  GroupMemberModel(
      {this.id, this.username, this.photo, this.firstName, this.lastName});

  GroupMemberModel.fromJson(Map<String, dynamic> json) {
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
