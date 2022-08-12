class ReminderModel {
  String? id;
  String? message;
  int? timeStamp;
  bool? isDone = false;
  bool? isSoundOn = false;

//<editor-fold desc="Data Methods">

  ReminderModel({
    this.id,
    this.message,
    this.timeStamp,
    this.isDone,
    this.isSoundOn,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          message == other.message &&
          timeStamp == other.timeStamp &&
          isDone == other.isDone &&
          isSoundOn == other.isSoundOn);

  @override
  int get hashCode =>
      id.hashCode ^
      message.hashCode ^
      timeStamp.hashCode ^
      isDone.hashCode ^
      isSoundOn.hashCode;

  @override
  String toString() {
    return 'ReminderModel{' +
        ' id: $id,' +
        ' message: $message,' +
        ' timeStamp: $timeStamp,' +
        ' isDone: $isDone,' +
        ' isSoundOn: $isSoundOn,' +
        '}';
  }

  ReminderModel copyWith({
    String? id,
    String? message,
    int? timeStamp,
    bool? isDone,
    bool? isSoundOn,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      message: message ?? this.message,
      timeStamp: timeStamp ?? this.timeStamp,
      isDone: isDone ?? this.isDone,
      isSoundOn: isSoundOn ?? this.isSoundOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'message': this.message,
      'timeStamp': this.timeStamp,
      'isDone': this.isDone,
      'isSoundOn': this.isSoundOn,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as String,
      message: map['message'] as String,
      timeStamp: map['timeStamp'] as int,
      isDone: map['isDone'] as bool,
      isSoundOn: map['isSoundOn'] as bool,
    );
  }

//</editor-fold>
}
