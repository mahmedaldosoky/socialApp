
class MessageModel {
  String messageText;
  String senderUid;
  String receiverUid;
  String dateTime;



  MessageModel({
    required this.messageText,
    required this.senderUid,
    required this.receiverUid,
    required this.dateTime,

  });

  static MessageModel fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageText: json['messageText'],
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      dateTime: json['dateTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageText': messageText,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'dateTime': dateTime,
    };
  }
}
