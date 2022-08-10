class ReminderModel {
  String? id;
  String? message;
  int? timeStamp;
  bool? isActive = true;

//<editor-fold desc="Data Methods">

  ReminderModel({
    this.id,
    this.message,
    this.timeStamp,
    this.isActive,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          message == other.message &&
          timeStamp == other.timeStamp &&
          isActive == other.isActive);

  @override
  int get hashCode =>
      id.hashCode ^ message.hashCode ^ timeStamp.hashCode ^ isActive.hashCode;

  @override
  String toString() {
    return 'ReminderModel{' +
        ' id: $id,' +
        ' message: $message,' +
        ' timeStamp: $timeStamp,' +
        ' isActive: $isActive,' +
        '}';
  }

  ReminderModel copyWith({
    String? id,
    String? message,
    int? timeStamp,
    bool? isActive,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      message: message ?? this.message,
      timeStamp: timeStamp ?? this.timeStamp,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'message': this.message,
      'timeStamp': this.timeStamp,
      'isActive': this.isActive,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as String,
      message: map['message'] as String,
      timeStamp: map['timeStamp'] as int,
      isActive: map['isActive'] as bool,
    );
  }

//</editor-fold>
}
