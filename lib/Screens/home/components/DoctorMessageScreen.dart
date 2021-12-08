import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:luan_van/model/User.dart';

import 'ChatScreen.dart';
import 'TabMessageScreen.dart';

class DoctorMessageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DoctorMessageScreenState();
}

List<UserModel> listUser = [];
List<LastMessage> listChat = [];

class DoctorMessageScreenState extends State<DoctorMessageScreen>{
  final fireStore = FirebaseFirestore.instance;
  Future<List<UserModel>> _dataFuture;
  Future<List<UserModel>> getUser() async {
    //TODO: Lọc đối tượng chat là bác sĩ.
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).get().then(
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
            if(!hasData && user.id != CurrentUser.currentUser.id && user.role == "admin")
              setState(() {
                listUser.add(user);
              });
          });
        }
    );
  }

  Future<void> getUserInfo(String id, String avatarUrl) async{
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(id).get().then((value) async{
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
          time = "bây giờ";
        else time = last.toString() + " phút trước";
      } else {
        time = (now.hour - timestamp.toDate().hour).toString() + " giờ trước";
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded, color: HexColor("392950"),)),
        backgroundColor: Colors.white,
        title: Center(child: Text("Nhắn tin", style: GoogleFonts.quicksand(color: HexColor("392950"), fontWeight: FontWeight.bold),)),
        actions: [
          SizedBox(width: 50,),
        ],
      ),
      body: Container(
        color: HexColor("392950"),
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text("Liên hệ admin: ",
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
              padding: EdgeInsets.only(left: 15),
              child: Text("Phản hồi người dùng: ",
                style: GoogleFonts.aBeeZee(
                  // textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height/30,
                ),
              ),
            ),

            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.only(top:15, right: 15, left: 15),
              height: MediaQuery.of(context).size.height * 3/5,
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
                      lastMessage.id = element.id.toString();//TODO
                      listChat.add(lastMessage);
                    });

                    if(listChat.length ==0)
                      return Center(
                        child: Text(
                          "- Không có hội thoại nào -",
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
                              child: Padding(
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
                                                    style: GoogleFonts.quicksand(                                                    color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(getLastTime(listChat[index].time),
                                                  style: GoogleFonts.quicksand(                                                  color: Colors.black,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
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
                                                  (listChat[index].isMe ? "Bạn: " : "") + listChat[index].content,
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
                      "Đang tải ...",
                      style: GoogleFonts.quicksand(                        color: Colors.white,
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
      ),
    );
  }
}