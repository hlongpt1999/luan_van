import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/bmi/EvaluateBMIScreen.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';
import 'package:luan_van/screens/setting/ChangeInfoScreen.dart';
import 'package:luan_van/screens/setting/ChangePasswordScreen.dart';
import 'package:luan_van/screens/setting/DatGioScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../testChat.dart';

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

  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 3/4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 2/7,
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
                      backgroundColor: Colors.blue,
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

                  Container(
                    padding: EdgeInsets.only(left: 10, right: 30),
                    child: Text(
                      CurrentUser.currentUser.name ?? "",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
/*
                  SizedBox(height: 25,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Flexible(
                          child: Text(
                            "BMI = " + CurrentUser.currentUser.bmi.toStringAsFixed(2).toString() ,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),

            SizedBox(height: 10,),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeInfoScreen()));
                },
                child: DrawerItem("Thay đổi thông tin", Icons.info_outline)),

            SizedBox(height: 10,),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                },
                child: DrawerItem("Thay đổi mật khẩu", Icons.password)),

            SizedBox(height: 10,),
            GestureDetector(
                onTap: (){
                  Const.KEY_FROM = Const.FROM_HOME;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BMIScreen()));
                },
                child: DrawerItem("Đánh giá sức khỏe", Icons.health_and_safety_outlined)),

            SizedBox(height: 10,),
            GestureDetector(
                onTap: (){
                  if(CurrentUser.lichHomNay)
                  showDialog(
                    context: context,
                    builder: (_context)=> AlertDialog(
                      title: Text("Tạo lịch cá nhân", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
                      content: Text("Hôm nay đang có lịch, bạn có muốn ghi đè lên lịch hôm nay?", style: GoogleFonts.quicksand(),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Không", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
                        ),
                        FlatButton(
                          onPressed: (){
                            CurrentUser.taoLichChoNgayMai = false;
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EvaluateBMIScreen()));
                          },
                          child: Text("Tiếp tục", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  );
                },
                child: DrawerItem("Tạo lịch cá nhân", Icons.calendar_today_outlined)),

            SizedBox(height: 10,),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DatGioScreen()));
                },
                child: DrawerItem("Đặt giờ nhắc nhở", Icons.alarm)),

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
              style: GoogleFonts.quicksand(
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
            title: Text("Đăng xuất", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
            content: Text("Bạn có muốn đăng xuất khỏi ứng dụng?", style: GoogleFonts.quicksand(),),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Không", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
              ),
              FlatButton(
                onPressed: (){
                  onLogOut(context);
                },
                child: Text("Có", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
      );
    });
  }
}