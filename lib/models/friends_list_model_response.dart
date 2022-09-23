import 'package:photos_app/dio_networking/decodable.dart';
import 'package:photos_app/models/user_model.dart';

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
  UserModel? userFk;
  UserModel? friendFk;
  String? friendRequestStatus;

  FriendsModel({this.id, this.userFk, this.friendFk, this.friendRequestStatus});

  FriendsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    userFk = json['user_fk'] != null
        ? new UserModel.fromJson(json['user_fk'])
        : null;
    friendFk = json['friend_fk'] != null
        ? new UserModel.fromJson(json['friend_fk'])
        : null;
    friendRequestStatus = json['friend_request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    if (this.friendFk != null) {
      data['friend_fk'] = this.friendFk!.toJson();
    }
    data['friend_request_status'] = this.friendRequestStatus;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    userFk = json['user_fk'] != null
        ? new UserModel.fromJson(json['user_fk'])
        : null;
    friendFk = json['friend_fk'] != null
        ? new UserModel.fromJson(json['friend_fk'])
        : null;
    friendRequestStatus = json['friend_request_status'];
    return this;
  }

  @override
  String toString() {
    return 'FriendsModel{id: $id, userFk: $userFk, friendFk: $friendFk, friendRequestStatus: $friendRequestStatus}';
  }
}
