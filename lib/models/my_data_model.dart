import 'package:photos_app/dio_networking/decodable.dart';

class MyDataModel implements Decodeable {
  int? id;

/*  int? parentFk;*/
  int? userFk;
  String? name;
  String? docFile;
  String? type;
  List<MyDataModel> subFolder = [];

  MyDataModel(
      {this.id,
      this.name,
      //this.parentFk,
      this.userFk,
      this.docFile,
      this.subFolder = const [],
      this.type});

  MyDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    //parentFk = json['parent_fk'];
    userFk = json['user_fk'];
    docFile = json['doc_file'];
    if (json['sub_folder'] != null) {
      subFolder = <MyDataModel>[];
      json['sub_folder'].forEach((v) {
        subFolder!.add(new MyDataModel.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
//    data['parent_fk'] = this.parentFk;
    data['user_fk'] = this.userFk;
    data['doc_file'] = this.docFile;
    if (this.subFolder != null) {
      data['sub_folder'] = this.subFolder.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    name = json['name'];
    //parentFk = json['parent_fk'];
    userFk = json['user_fk'];
    docFile = json['doc_file'];
    if (json['sub_folder'] != null) {
      subFolder = <MyDataModel>[];
      json['sub_folder'].forEach((v) {
        subFolder.add(new MyDataModel.fromJson(v));
      });
    }
    type = json['type'];
    return this;
  }

  @override
  String toString() {
    return 'MyDataModel{id: $id, name: $name, userFk: $userFk, docFile: $docFile, type: $type, subFolder: $subFolder}';
  }
}
