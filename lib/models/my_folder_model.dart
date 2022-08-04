import 'package:flutter/cupertino.dart';

class MyMenuItem {
  String? id;
  String? name;
  Widget? icon;
  bool isPrivate;
  bool isPinned;
  bool isFolder;
  List<MyMenuItem> subItemList = [];

//<editor-fold desc="Data Methods">

  MyMenuItem({
    this.id,
    this.name,
    this.icon,
    this.isPrivate = false,
    this.isPinned = false,
    this.isFolder = false,
    this.subItemList = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyMenuItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          isPrivate == other.isPrivate &&
          isPinned == other.isPinned &&
          isFolder == other.isFolder &&
          subItemList == other.subItemList);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      icon.hashCode ^
      isPrivate.hashCode ^
      isPinned.hashCode ^
      isFolder.hashCode ^
      subItemList.hashCode;

  @override
  String toString() {
    return 'MyMenuItem{' +
        ' id: $id,' +
        ' name: $name,' +
        ' icon: $icon,' +
        ' isPrivate: $isPrivate,' +
        ' isPinned: $isPinned,' +
        ' isFolder: $isFolder,' +
        ' subItemList: $subItemList,' +
        '}';
  }

  MyMenuItem copyWith({
    String? id,
    String? name,
    Widget? icon,
    bool? isPrivate,
    bool? isPinned,
    bool? isFolder,
    List<MyMenuItem>? subItemList,
  }) {
    return MyMenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isPrivate: isPrivate ?? this.isPrivate,
      isPinned: isPinned ?? this.isPinned,
      isFolder: isFolder ?? this.isFolder,
      subItemList: subItemList ?? this.subItemList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'icon': this.icon,
      'isPrivate': this.isPrivate,
      'isPinned': this.isPinned,
      'isFolder': this.isFolder,
      'subItemList': this.subItemList,
    };
  }

  factory MyMenuItem.fromMap(Map<String, dynamic> map) {
    return MyMenuItem(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as Widget,
      isPrivate: map['isPrivate'] as bool,
      isPinned: map['isPinned'] as bool,
      isFolder: map['isFolder'] as bool,
      subItemList: map['subItemList'] as List<MyMenuItem>,
    );
  }

//</editor-fold>
}
