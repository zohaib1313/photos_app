import 'package:photos_app/dio_networking/decodable.dart';

class NotesResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<NotesModel>? results;

  NotesResponseModel({this.count, this.next, this.previous, this.results});

  NotesResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <NotesModel>[];
      json['results'].forEach((v) {
        results!.add(new NotesModel.fromJson(v));
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
      results = <NotesModel>[];
      json['results'].forEach((v) {
        results!.add(new NotesModel.fromJson(v));
      });
    }
    return this;
  }
}

class NotesModel implements Decodeable {
  int? id;
  String? name;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? userFk;

  NotesModel(
      {this.id,
      this.name,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.userFk});

  NotesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk = json['user_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_fk'] = this.userFk;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    name = json['name'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk = json['user_fk'];
    return this;
  }
}
