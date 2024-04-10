class MessageModel {
  String sendID;
  String receiveID;
  String message;
  bool? read;
  String sendDate;

  MessageModel(
      {required this.sendID,
      required this.receiveID,
      required this.message,
      this.read,
      required this.sendDate});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      sendID: json["sendID"],
      receiveID: json["receiveID"],
      message: json["message"],
      read: json["read"],
      sendDate: json["sendDate"]);

  Map<String, dynamic> toJson() => {
        "sendID": sendID,
        "receiveID": receiveID,
        "message": message,
        "read": read,
        "sendDate": sendDate,
      };
}
