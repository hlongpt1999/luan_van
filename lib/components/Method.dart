import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luan_van/model/ChatModel.dart';

Future<void> getChat(String idSender, String idReceiver) async {
  await FirebaseFirestore.instance.collection("users").doc(idSender).collection("chat").get().then(
          (value){
        value.docs.forEach((element) async {
          var data = element.data() as Map<String, dynamic>;
          ChatModel chatModel = new ChatModel.fromJson(data);
        });
      }
  );
}