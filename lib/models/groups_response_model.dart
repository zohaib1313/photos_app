import 'package:photos_app/dio_networking/decodable.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/user_model.dart';

class GroupListResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<GroupModel>? groupModelList;

  GroupListResponseModel(
      {this.count, this.next, this.previous, this.groupModelList});

  GroupListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      groupModelList = <GroupModel>[];
      json['results'].forEach((v) {
        groupModelList!.add(new GroupModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.groupModelList != null) {
      data['results'] = this.groupModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      groupModelList = <GroupModel>[];
      json['results'].forEach((v) {
        groupModelList!.add(new GroupModel.fromJson(v));
      });
    }
    return this;
  }
}

class GroupModel implements Decodeable {
  int? id;
  String? groupName;
  String? description;
  String? groupPhoto;
  String? createdAt;
  String? updatedAt;
  UserModel? adminFk;
  List<GroupContent>? groupContent;
  List<UserModel>? members;
  int? membersCount;

  GroupModel(
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

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    description = json['description'];
    groupPhoto = json['group_photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminFk = json['admin_fk'] != null
        ? new UserModel.fromJson(json['admin_fk'])
        : null;
    if (json['group_content'] != null) {
      groupContent = <GroupContent>[];
      json['group_content'].forEach((v) {
        groupContent!.add(new GroupContent.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <UserModel>[];
      json['members'].forEach((v) {
        members!.add(new UserModel.fromJson(v));
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

  @override
  decode(json) {
    id = json['id'];
    groupName = json['group_name'];
    description = json['description'];
    groupPhoto = json['group_photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminFk = json['admin_fk'] != null
        ? new UserModel.fromJson(json['admin_fk'])
        : null;
    if (json['group_content'] != null) {
      groupContent = <GroupContent>[];
      json['group_content'].forEach((v) {
        groupContent!.add(new GroupContent.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <UserModel>[];
      json['members'].forEach((v) {
        members!.add(new UserModel.fromJson(v));
      });
    }
    membersCount = json['members_count'];
    return this;
  }
}

class GroupContent {
  int? id;
  String? createdAt;
  String? updatedAt;
  UserModel? userFk;
  int? groupFk;
  MyDataModel? contentFk;

  GroupContent(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.userFk,
      this.groupFk,
      this.contentFk});

  GroupContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk = json['user_fk'] != null
        ? new UserModel.fromJson(json['user_fk'])
        : null;
    groupFk = json['group_fk'];
    contentFk = json['content_fk'] != null
        ? new MyDataModel.fromJson(json['content_fk'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['group_fk'] = this.groupFk;
    if (this.contentFk != null) {
      data['content_fk'] = this.contentFk!.toJson();
    }
    return data;
  }
}
