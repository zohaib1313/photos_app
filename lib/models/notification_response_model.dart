import 'package:photos_app/dio_networking/decodable.dart';

class NotificationsResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<NotificationModel>? notificationList;

  NotificationsResponseModel(
      {this.count, this.next, this.previous, this.notificationList});

  NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      notificationList = <NotificationModel>[];
      json['results'].forEach((v) {
        notificationList!.add(new NotificationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.notificationList != null) {
      data['results'] = this.notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      notificationList = <NotificationModel>[];
      json['results'].forEach((v) {
        notificationList!.add(new NotificationModel.fromJson(v));
      });
    }
    return this;
  }
}

class NotificationModel implements Decodeable {
  int? id;
  int? sender;
  int? receiver;
  String? title;
  String? body;
  String? createdAt;
  bool? isRead;
  bool? isDeleted;

  NotificationModel(
      {this.id,
      this.sender,
      this.receiver,
      this.title,
      this.body,
      this.createdAt,
      this.isRead,
      this.isDeleted});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    receiver = json['receiver'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['is_read'] = this.isRead;
    data['is_deleted'] = this.isDeleted;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    sender = json['sender'];
    receiver = json['receiver'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
    isDeleted = json['is_deleted'];
    return this;
  }
}
