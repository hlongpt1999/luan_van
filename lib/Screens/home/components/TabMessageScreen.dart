import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/model/ChatModel.dart';
import 'package:luan_van/model/User.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:luan_van/resources/styles.dart';

import 'ChatScreen.dart';

List<UserModel> listUser = [];

class TabMessageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TabMessageScreenState();
}

class TabMessageScreenState extends State<TabMessageScreen>{
  final fireStore = FirebaseFirestore.instance;
  List<LastMessage> listChat = [];
  Future<List<UserModel>> _dataFuture;
  Future<List<UserModel>> getUser() async {

    await FirebaseFirestore.instance.collection("users").get().then(
            (value){
          value.docs.forEach((element) async {
            var data = element.data() as Map<String, dynamic>;
            UserModel user = new UserModel.fromJson(data);
            var ref = firebase_storage.FirebaseStorage.instance.ref(user.avatar);
            user.avatar = await ref.getDownloadURL();

            bool hasData = false;
            for (int i=0; i< listUser.length ;i++){
              if(user.id == listUser[i].id) hasData = true;
            }
            if(!hasData && user.id != CurrentUser.currentUser.id && user.role == "doctor")
            setState(() {
              listUser.add(user);
            });
          });
        }
    );
    return listUser;
  }

  Future<void> getUserInfo(String id, String avatarUrl) async{
    await FirebaseFirestore.instance.collection('users').doc(id).get().then((value) async{
      var data = value.data() as Map<String, dynamic>;
      CurrentUser.userConnect.name = data['name'];
      CurrentUser.userConnect.email = data['email'];
      CurrentUser.userConnect.avatar = avatarUrl;
      CurrentUser.userConnect.id = data['id'];
      CurrentUser.userConnect.role = data['role'];
      CurrentUser.userConnect.bmi = data['bmi'];
    }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen())));
  }

  String getLastTime(Timestamp timestamp){
    final now = DateTime.now();
    String time ="";
    if(now.day==timestamp.toDate().day && now.month==timestamp.toDate().month
        && now.year==timestamp.toDate().year){
      if(now.hour==timestamp.toDate().hour){
        int last = now.minute - timestamp.toDate().minute;
        if (last == 0)
          time = "b??y gi???";
        else time = last.toString() + " ph??t tr?????c";
      } else {
        time = (now.hour - timestamp.toDate().hour).toString() + " gi??? tr?????c";
      }
    }
    else time = DateFormat("dd/M").format(timestamp.toDate());
    return time;
  }

  @override
  void initState() {
    _dataFuture = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text("Nh???n tin t?? v???n\nv???i chuy??n gia",
              style: GoogleFonts.quicksand(
                // textStyle: Theme.of(context).textTheme.headline4,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height/30,
              ),
            ),
          ),

          SizedBox(height: 10,),

          FutureBuilder(
            future: _dataFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return Container(
                // padding: EdgeInsets.only(left: 20),
                height: MediaQuery.of(context).size.height/15,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listUser.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          CurrentUser.userConnect = listUser[index];
                        });
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen()));
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          Container(
                            width: MediaQuery.of(context).size.height/15,
                            height: MediaQuery.of(context).size.height/15,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(180))
                            ),
                            // child: Text("AAA"),
                            child:  CircleAvatar(
                              backgroundImage: NetworkImage(listUser[index].avatar),
                            )
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          SizedBox(height: 20,),

          Container(
            padding: EdgeInsets.only(top:15, right: 15, left: 15),
            height: MediaQuery.of(context).size.height * 8/15,
            decoration: BoxDecoration(
                color: MyColor.colorBackgroundTab,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))
            ),
            child: StreamBuilder(
              stream: fireStore.collection('users').doc(CurrentUser.currentUser.id).collection("lastMessage").orderBy('time', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasData){
                  listChat.clear();
                  var chat = snapshot.data.docs;
                  chat.forEach((element) {
                    var data = element.data();
                    LastMessage lastMessage = new LastMessage.fromJson(data);
                    lastMessage.id = element.id.toString();
                    listChat.add(lastMessage);
                  });

                  if(listChat.length ==0)
                    return Center(
                      child: Text(
                        "- Kh??ng c?? h???i tho???i n??o -",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                        ),
                      ),
                    );
                  else
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: listChat.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              getUserInfo(listChat[index].id, listChat[index].avatar);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: MediaQuery.of(context).size.height/7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.height/7 - 30,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(listChat[index].avatar),
                                        radius: MediaQuery.of(context).size.height/7 - 30,
                                      ),
                                    ),

                                    SizedBox(width: 15,),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width* 178/500,
                                                child: Text(
                                                  listChat[index].name,
                                                  style: GoogleFonts.quicksand(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 7,),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                width: 82,
                                                child: Text(
                                                  getLastTime(listChat[index].time),
                                                  style: GoogleFonts.quicksand(
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width* 5/9,
                                            alignment: Alignment.centerLeft,
                                            child: Flexible(
                                              child: Text(
                                                (listChat[index].isMe ? "B???n: " : "") + listChat[index].content,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    );
                }
                return Center(
                  child: Text(
                    "??ang t???i ...",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    ),
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}

class LastMessage{
  String id;
  String name;
  String avatar;
  String content;
  bool isMe;
  Timestamp time;

  LastMessage({this.name, this.avatar, this.content, this.isMe, this.time});

  LastMessage.fromJson(Map<String, dynamic> json){
    name = json["name"] ?? "";
    avatar = json["avatar"] ?? "";
    content= json["content"] ?? "";
    time= json["time"];
    isMe= json["isMe"] ?? false;
  }

  Map<String, dynamic> toMap(){
    return {
      "name" : name,
      "avatar" : avatar,
      "content" : content,
      "time" : time,
      "isMe" : isMe,
    };
  }
}