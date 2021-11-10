import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/model/User.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'ChatScreen.dart';

List<UserModel> listUser = [];

class TabMessageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TabMessageScreenState();
}

class TabMessageScreenState extends State<TabMessageScreen>{
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
            if(!hasData)
            setState(() {
              listUser.add(user);
            });
          });
        }
    );
    return listUser;
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
          Text("Nhắn tin tư vấn\nvới chuyên gia",
            style: GoogleFonts.roboto(
              // textStyle: Theme.of(context).textTheme.headline4,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height/30,
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

                            // listUser[index].avatar !=null
                            //     ? NetworkImage(snapshot.data[index].avatar)
                            //     :
                            // Image.asset("assets/fitness_app/breakfast.png",),
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
            height: MediaQuery.of(context).size.height * 3/5,
            decoration: BoxDecoration(
                color: MyColor.colorBackgroundTab,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))
            ),
          ),
        ],
      ),
    );
  }
}