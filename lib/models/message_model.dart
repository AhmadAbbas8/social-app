class MessageModel {
  String? senderId, receiverId, dateTime, txt;

  MessageModel({
    this.txt,
    this.dateTime,
    this.receiverId,
    this.senderId,
  });

  MessageModel.fromJson({required Map<String, dynamic> json}) {
    txt = json['txt'];
    dateTime = json['dateTime'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'dateTime': dateTime,
      'receiverId': receiverId,
      'txt': txt,
    };
  }
}
