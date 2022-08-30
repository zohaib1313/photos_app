import 'package:photos_app/dio_networking/decodable.dart';

class RemindersResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<ReminderModel>? results;

  RemindersResponseModel({this.count, this.next, this.previous, this.results});

  RemindersResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ReminderModel>[];
      json['results'].forEach((v) {
        results!.add(new ReminderModel.fromJson(v));
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
      results = <ReminderModel>[];
      json['results'].forEach((v) {
        results!.add(new ReminderModel.fromJson(v));
      });
    }
    return this;
  }
}

class ReminderModel {
  int? id;
  String? description;
  String? reminderTime;
  String? createdAt;
  int? userFk;

  ReminderModel(
      {this.id,
      this.description,
      this.reminderTime,
      this.createdAt,
      this.userFk});

  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    reminderTime = json['reminder_time'];
    createdAt = json['created_at'];
    userFk = json['user_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['reminder_time'] = this.reminderTime;
    data['created_at'] = this.createdAt;
    data['user_fk'] = this.userFk;
    return data;
  }
}
