// 用户模型
class UserModel {
  String userID;
  String providerUID;
  String userName;

  UserModel(
      {required this.userID,
      required this.providerUID,
      required this.userName});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userID: json["userID"],
      providerUID: json["providerUID"],
      userName: json["userName"]);

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "providerUID": providerUID,
        "userName": userName,
      };
}
