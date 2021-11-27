import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/main.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/data/ThemBaiTapScreen.dart';
import 'package:luan_van/screens/data/ThemFood.dart';
import 'package:luan_van/screens/home/components/DoctorMessageScreen.dart';
import 'package:luan_van/screens/login/Login.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';

class DoctorHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DoctorHomeScreenState();
}

class ItemGrid {
  String linkImage;
  String tenItem;
  String mota;
  String from;
  Route to;

  ItemGrid({this.linkImage, this.tenItem, this.mota, this.from, this.to});
}

class DoctorHomeScreenState extends State<DoctorHomeScreen>{
  List<ItemGrid> listItems = [
    ItemGrid(tenItem: "thực phẩm", mota: "Thêm thực phẩm để lập thời gian biểu", linkImage: "assets/fitness_app/lunch.png"),
    ItemGrid(tenItem: "động tác", mota: "Thêm các động tác luyện", linkImage: "assets/fitness_app/runner.png"),
    ItemGrid(tenItem: "Chế độ ăn uống", mota: "Thêm lịch ăn uống tuần", linkImage: "assets/fitness_app/bento.png"),
    ItemGrid(tenItem: "luyện tập", mota: "Thêm các chế độ tập luyện theo tuần", linkImage: "assets/fitness_app/luyentap.png"),
    ItemGrid(tenItem: "Nhắn tin", mota: "Nhắn tin tư vấn cho người dùng", linkImage: "assets/fitness_app/message.png"),
  ];

  String url = "";
  Future<void> getAvatar() async{
    var ref = firebase_storage.FirebaseStorage.instance.ref(CurrentUser.currentUser.avatar);
    String string = await ref.getDownloadURL();
    setState(() {
      url = string;
    });
  }

  @override
  void initState() {
    getAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("392950"),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.bottomRight,
                height: MediaQuery.of(context).size.height * 1/10,
                child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (_context)=> AlertDialog(
                            title: Text("Đăng xuất", style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                            ),),
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
                    },
                    child: Icon(Icons.logout, size: 40, color: Colors.white,)),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 1/4,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(
                      child: Text(
                        "Xin chào,\n\n" + (CurrentUser.currentUser.name ?? "").toUpperCase(),
                        style: GoogleFonts.quicksand(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(180)),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(url),
                        radius: 80,
                      ),
                    ),

                    SizedBox(width: 10,),
                  ],
                ),

              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                  children: List.generate(
                    listItems.length,
                      (index) {
                        return GestureDetector(
                          onTap: (){
                            switch(index){
                              case 0:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ThemFood()));
                                break;
                              case 1:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ThemBaiTapScreen()));
                                break;
                              case 2:
                                Const.KEY_FROM = Const.FROM_CREATE_SCHEDULE;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                break;
                              case 3:
                                Const.KEY_FROM = Const.FROM_CREATE_SCHEDULE_LUYENTAP;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                break;
                              case 4:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorMessageScreen()));
                                break;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.width/2 - 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(listItems[index].linkImage, width: 80, height: 80,),

                                Text(
                                  listItems[index].tenItem.toUpperCase(),
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                        listItems[index].mota,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white.withOpacity(0.2),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 1/10,),
            ],
          ),
        ),
      ),
    );
  }
}