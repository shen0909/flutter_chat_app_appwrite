class FriendModel{
  String myUserId;
  String myUserName;
  String friendUserId;
  String friendsUserName;


  FriendModel({required this.myUserId, required this.myUserName, required this.friendUserId,
    required this.friendsUserName});

  factory FriendModel.fromJson(Map<String,dynamic> json) =>FriendModel(
    myUserId:json["myUserId"],
    myUserName:json["myUserName"],
    friendUserId:json["friendUserId"],
    friendsUserName:json["friendsUserName"],
  );

  Map<String,dynamic> toJson() =>{
    "myUserId":myUserId,
    "myUserName":myUserName,
    "friendUserId":friendUserId,
    "friendsUserName":friendsUserName,
  };
}