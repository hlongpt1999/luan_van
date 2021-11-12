import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/ChatModel.dart';
import 'package:luan_van/screens/home/components/TabMessageScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

List<ChatModel> listChat = [];

List<bool> test=[true, false,true, false,false, false, true ,true, false,true, false,true, false,
  true, false,true, false,true, false,true, false,
  true, false,true];

class ChatScreenState extends State<ChatScreen>{
  int chatLength = 10;
  double textFieldSize = 61, padding = 15;
  Color colorTrai = Colors.purpleAccent;
  Color colorPhai = Colors.orangeAccent;
  Color colorBackground = Colors.white;
  Color textColor = Colors.white;
  Color timeColor = Colors.white;

  final fireStore = FirebaseFirestore.instance;
  TextEditingController textEditingController = new TextEditingController();
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    super.initState();
  }

  String getTime(Timestamp timestamp){
    final now = DateTime.now();
    String time ="";
    if(now.day==timestamp.toDate().day && now.month==timestamp.toDate().month
    && now.year==timestamp.toDate().year)
      time = DateFormat('kk:mm').format(timestamp.toDate());
    else time = DateFormat("kk:mm dd/M").format(timestamp.toDate());
    return time;
  }

  void scrollListener(){
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange){
      if(chatLength < listChat.length){
        setState(() {
          chatLength += 10;
        });
      }
    }
  }

  Future<void> sendMessage() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var idSender = CurrentUser.currentUser.id;
    var idReceiver = CurrentUser.userConnect.id;
    var content = textEditingController.text.toString();
    var time = Timestamp. fromDate(DateTime. now());

    textEditingController.text = "";

    LastMessage lastMessage = LastMessage(
      name: CurrentUser.userConnect.name,
      avatar: CurrentUser.userConnect.avatar,
      content: content,
      time: time,
      isMe: true,
    );
    ChatModel chatModel = ChatModel(
        idSender: idSender,
        content: content,
        time: time,
        isMe: true,
    );
    await firebaseFirestore.collection('users').doc(idSender).collection(idReceiver).add(chatModel.toMap());
    print("111111");
    await firebaseFirestore.collection('users').doc(idSender).collection("lastMessage").doc(idReceiver).set(lastMessage.toMap());
    print("222222");

    var ref = firebase_storage.FirebaseStorage.instance.ref(CurrentUser.currentUser.avatar);
    String avatar = await ref.getDownloadURL();

    LastMessage lastMessageReceiver = LastMessage(
      name: CurrentUser.currentUser.name,
      avatar: avatar,
      content: content,
      time: time,
      isMe: true,
    );
    ChatModel chatForReceiver = ChatModel(
      idSender: idSender,
      content: content,
      time: time,
      isMe: false,
    );
    await firebaseFirestore.collection('users').doc(idReceiver).collection(idSender).add(chatForReceiver.toMap());
    print("33333");
    await firebaseFirestore.collection('users').doc(idReceiver).collection("lastMessage").doc(idSender).set(lastMessageReceiver.toMap());
    print("44444");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded)),
        title: Text(CurrentUser.userConnect.name),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(CurrentUser.userConnect.avatar),
          ),

          SizedBox(width: 20,),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.yellow,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: textFieldSize + padding),
              alignment: Alignment.bottomCenter,
              height: double.infinity,
              width: double.infinity,
              color: colorBackground,
              child: StreamBuilder(
                stream: fireStore.collection('users').doc(CurrentUser.currentUser.id).collection(CurrentUser.userConnect.id).orderBy('time', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    listChat.clear();
                    var chat = snapshot.data.docs;
                    chat.forEach((element) {
                      var data = element.data();
                      ChatModel chatModel = new ChatModel.fromJson(data);
                      listChat.add(chatModel);
                    });

                  return ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    // shrinkWrap: true,
                    itemCount: listChat.length > chatLength ? chatLength : listChat.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Wrap(
                        children: [
                          listChat[index].isMe

                          ? Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 3/4),
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                                    decoration: BoxDecoration(
                                      color: colorPhai,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(22.0),
                                        bottomLeft: Radius.circular(22.0),
                                        topLeft: Radius.circular(22.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(listChat[index].content,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/22,
                                            color: textColor,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(getTime(listChat[index].time),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/28,
                                            color: timeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: colorPhai,
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: colorBackground,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(180.0),
                                      ),
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          )

                          :Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: colorTrai,
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: colorBackground,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(180.0),
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 3/4),
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: colorTrai,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(22.0),
                                      bottomLeft: Radius.circular(22.0),
                                      topRight: Radius.circular(22.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(listChat[index].content,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/22,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                         getTime(listChat[index].time),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/30,
                                          color: timeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                  return CupertinoActivityIndicator();
                }
              ),
            ),

            Container(
              margin: EdgeInsets.all(padding),
              height: textFieldSize,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 5,
                              color: Colors.grey)
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.face , color: Colors.blueAccent,), onPressed: () {}),
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  hintText: "Nhập tin nhắn.",
                                  hintStyle: TextStyle( color:  Colors.blueAccent),
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.photo_camera ,  color: Colors.blueAccent),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_file ,  color: Colors.blueAccent),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    child: InkWell(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onTap: (){
                        if(textEditingController.text.isNotEmpty || textEditingController.text != "")
                        sendMessage();
                      },
                    ),
                  )
                ],
              ),
            ) ,
          ],
        ),
      ),
    );
  }
}