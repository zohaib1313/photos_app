import 'package:photos_app/dio_networking/decodable.dart';

import 'my_data_model.dart';

class MyDataModelResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<MyDataModel>? results;

  MyDataModelResponseModel(
      {this.count, this.next, this.previous, this.results});

  MyDataModelResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <MyDataModel>[];
      json['results'].forEach((v) {
        results!.add(new MyDataModel.fromJson(v));
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
      results = <MyDataModel>[];
      json['results'].forEach((v) {
        results!.add(MyDataModel.fromJson(v));
      });
    }
    return this;
  }
}
