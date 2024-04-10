// 消息列表
class ChatMessageList {
  String sendId;
  String receiveId;
  String message;
  bool? read;
  String sendDate;
  String displayName;
  String key; // 密钥 =  发送者ID + 接收者ID
  int? count;

  ChatMessageList(
      {required this.sendId,
      required this.receiveId,
      required this.message,
      this.read,
      required this.sendDate,
      required this.displayName,
      required this.key,
      this.count});

  factory ChatMessageList.fromJson(Map<String, dynamic> json) =>
      ChatMessageList(
        sendId: json["sendId"],
        receiveId: json["receiveId"],
        message: json["message"],
        read: json["read"],
        sendDate: json["sendDate"],
        displayName: json["displayName"],
        key: json["key"],
        count: json["count"],
      );

  Map<String,dynamic> toJson() => {
    "sendId": sendId,
    "receiveId": receiveId,
    "message": message,
    "read": read,
    "sendDate": sendDate,
    "displayName": displayName,
    "key": key,
    "count": count,
  };
}
