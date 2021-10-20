import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';

class MyDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> MyDrawerState();
}


class MyDrawerState extends State<MyDrawer>{
  double _sizeAvatar = 50;
  String avatarURL = "";
  Future<void> loadAvatar() async {
    var ref = firebase_storage.FirebaseStorage.instance
        .ref(CurrentUser.currentUser.avatar);
    String avatar = await ref.getDownloadURL();
    setState(() {
      avatarURL = avatar;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 3/4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 2/5,
              width: MediaQuery.of(context).size.width * 3/4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Colors.blue[100],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
              ),
              child: Column(
                children: [
                  SizedBox(height: MySize.heightAppBar * 2/3,),

                  GestureDetector(
                    onTap: (){},
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: _sizeAvatar,
                      child: CircleAvatar(
                        backgroundImage: avatarURL != ""
                          ? NetworkImage(avatarURL)
                              : AssetImage('assets/home.jpeg'),
                        radius: _sizeAvatar - 3,
                      ),
                    ),
                  ),

                  SizedBox(height: 5,),

                  Text(
                    CurrentUser.currentUser.name ?? "",
                    //TODO: Nhap ten nguoi dung o day.
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 25,),

                  Container(
                    child: Row(
                      children: [

                        SizedBox(width: 25,),

                        Text(
                          "BMI = ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),

                        Text(
                          CurrentUser.currentUser.bmi ?? "",
                          //TODO: BMI index
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),
            DrawerItem("Thay đổi mật khẩu", Icons.password),

            SizedBox(height: 10,),
            DrawerItem("FAQs", Icons.question_answer),

            SizedBox(height: 10,),
            GestureDetector(
                onTap: handleLogOut,
                child: DrawerItem("Đăng xuất", Icons.logout_outlined)),
            SizedBox(height: 40,),

          ],
        ),
      ),
    );
  }

  Widget DrawerItem(String _title, IconData _icon){
    double _radiusRight = 30;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[300],
            Colors.blue[100],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.horizontal(right: Radius.circular(_radiusRight))
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              _title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          Container(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: _radiusRight,
                child: Icon(
                    _icon,
                  color: Colors.black,
                ),
            ),
          ),

        ],
      ),
    );
  }

  void handleLogOut(){
    setState(() {
      showDialog(
          context: context,
          builder: (_context)=> AlertDialog(
            title: Text("Đăng xuất"),
            content: Text("Bạn có muốn đăng xuất khỏi ứng dụng?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Không"),
              ),
              FlatButton(
                onPressed: () {
                  CurrentUser.currentUser = UserModel();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text("Có"),
              ),
            ],
          ),
      );
    });
  }
}