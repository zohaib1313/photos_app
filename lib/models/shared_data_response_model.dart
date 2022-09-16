import 'package:photos_app/dio_networking/decodable.dart';
import 'package:photos_app/models/user_model.dart';

import 'my_data_model.dart';

class SharedReceivedDataResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<SharedReceivedDataModel> sharedReceivedDataModelList = [];

  SharedReceivedDataResponseModel(
      {this.count,
      this.next,
      this.previous,
      this.sharedReceivedDataModelList = const []});

  SharedReceivedDataResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      sharedReceivedDataModelList = <SharedReceivedDataModel>[];
      json['results'].forEach((v) {
        sharedReceivedDataModelList
            .add(new SharedReceivedDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.sharedReceivedDataModelList != null) {
      data['results'] =
          this.sharedReceivedDataModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      sharedReceivedDataModelList = <SharedReceivedDataModel>[];
      json['results'].forEach((v) {
        sharedReceivedDataModelList!
            .add(new SharedReceivedDataModel.fromJson(v));
      });
    }
    return this;
  }

  @override
  String toString() {
    return 'SharedReceivedDataResponseModel{count: $count, next: $next, previous: $previous, sharedReceivedDataModelList: $sharedReceivedDataModelList}';
  }
}

class SharedReceivedDataModel extends Decodeable {
  int? id;
  String? createdAt;
  String? updatedAt;
  UserModel? sharedByFk;
  UserModel? sharedWithFk;
  MyDataModel? contentFk;

  SharedReceivedDataModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.sharedByFk,
      this.sharedWithFk,
      this.contentFk});

  SharedReceivedDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sharedByFk = json['shared_by_fk'] != null
        ? new UserModel.fromJson(json['shared_by_fk'])
        : null;
    sharedWithFk = json['shared_with_fk'] != null
        ? new UserModel.fromJson(json['shared_with_fk'])
        : null;
    contentFk = json['content_fk'] != null
        ? new MyDataModel.fromJson(json['content_fk'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sharedByFk != null) {
      data['shared_by_fk'] = this.sharedByFk!.toJson();
    }
    if (this.sharedWithFk != null) {
      data['shared_with_fk'] = this.sharedWithFk!.toJson();
    }
    if (this.contentFk != null) {
      data['content_fk'] = this.contentFk!.toJson();
    }
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sharedByFk = json['shared_by_fk'] != null
        ? new UserModel.fromJson(json['shared_by_fk'])
        : null;
    sharedWithFk = json['shared_with_fk'] != null
        ? new UserModel.fromJson(json['shared_with_fk'])
        : null;
    contentFk = json['content_fk'] != null
        ? new MyDataModel.fromJson(json['content_fk'])
        : null;
    return this;
  }

  @override
  String toString() {
    return 'SharedReceivedDataModel{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, sharedByFk: $sharedByFk, sharedWithFk: $sharedWithFk, contentFk: $contentFk}';
  }
}
