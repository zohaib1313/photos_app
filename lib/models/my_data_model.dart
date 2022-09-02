import 'package:photos_app/dio_networking/decodable.dart';

class MyDataModel  implements Decodeable{
  int? id;
  String? name;
  String? parentFk;
  int? userFk;
  String? docFile;
  List<SubFolder>? subFolder;
  String? type;

  MyDataModel(
      {this.id,
        this.name,
        this.parentFk,
        this.userFk,
        this.docFile,
        this.subFolder,
        this.type});

  MyDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentFk = json['parent_fk'];
    userFk = json['user_fk'];
    docFile = json['doc_file'];
    if (json['sub_folder'] != null) {
      subFolder = <SubFolder>[];
      json['sub_folder'].forEach((v) {
        subFolder!.add(new SubFolder.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_fk'] = this.parentFk;
    data['user_fk'] = this.userFk;
    data['doc_file'] = this.docFile;
    if (this.subFolder != null) {
      data['sub_folder'] = this.subFolder!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    name = json['name'];
    parentFk = json['parent_fk'];
    userFk = json['user_fk'];
    docFile = json['doc_file'];
    if (json['sub_folder'] != null) {
      subFolder = <SubFolder>[];
      json['sub_folder'].forEach((v) {
        subFolder!.add(new SubFolder.fromJson(v));
      });
    }
    type = json['type'];
    return this;
  }
}

class SubFolder {
  int? id;
  String? name;
  int? parentFk;
  int? userFk;
  String? docFile;
  List<SubFolder>? subFolder;
  String? type;

  SubFolder(
      {this.id,
        this.name,
        this.parentFk,
        this.userFk,
        this.docFile,
        this.subFolder,
        this.type});

  SubFolder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentFk = json['parent_fk'];
    userFk = json['user_fk'];
    docFile = json['doc_file'];
    if (json['sub_folder'] != null) {
      subFolder = <SubFolder>[];
      json['sub_folder'].forEach((v) {
        subFolder!.add(new SubFolder.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_fk'] = this.parentFk;
    data['user_fk'] = this.userFk;
    data['doc_file'] = this.docFile;
    if (this.subFolder != null) {
      data['sub_folder'] = this.subFolder!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }
}