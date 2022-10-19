import 'package:photos_app/dio_networking/decodable.dart';

class DeviceTokensResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<DeviceTokenModel>? results;

  DeviceTokensResponseModel(
      {this.count, this.next, this.previous, this.results});

  @override
  String toString() {
    return 'DeviceTokensResponseModel{count: $count, next: $next, previous: $previous, results: $results}';
  }

  DeviceTokensResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <DeviceTokenModel>[];
      json['results'].forEach((v) {
        results!.add(new DeviceTokenModel.fromJson(v));
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

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <DeviceTokenModel>[];
      json['results'].forEach((v) {
        results!.add(new DeviceTokenModel.fromJson(v));
      });
    }
    return this;
  }
}

class DeviceTokenModel implements Decodeable {
  int? id;
  int? receiverId;
  String? deviceId;
  String? deviceToken;
  bool? toNotify;

  DeviceTokenModel(
      {this.id,
      this.receiverId,
      this.deviceId,
      this.deviceToken,
      this.toNotify});

  @override
  String toString() {
    return 'DeviceTokenModel{id: $id, receiverId: $receiverId, deviceId: $deviceId, deviceToken: $deviceToken, toNotify: $toNotify}';
  }

  DeviceTokenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
    toNotify = json['to_notify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_id'] = this.receiverId;
    data['device_id'] = this.deviceId;
    data['device_token'] = this.deviceToken;
    data['to_notify'] = this.toNotify;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
    toNotify = json['to_notify'];
    return this;
  }
}
