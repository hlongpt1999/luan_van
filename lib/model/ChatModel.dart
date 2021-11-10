import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel{
  String idSender = "";
  String content = "";
  Timestamp time;
  bool isMe = false;

  ChatModel({this.idSender, this.content, this.time, this.isMe});

  ChatModel.fromJson(Map<String, dynamic> json){
    idSender = json["idSender"] ?? "";
    content= json["content"] ?? "";
    time= json["time"];
    isMe= json["isMe"] ?? false;
  }

  Map<String, dynamic> toMap(){
    return {
      "idSender" : idSender,
      "content" : content,
      "time" : time,
      "isMe" : isMe,
    };
  }
}