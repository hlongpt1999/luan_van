import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/main.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    ItemGrid(tenItem: "món ăn", mota: "Thêm món ăn để lập thời gian biểu", linkImage: "assets/fitness_app/lunch.png"),
    ItemGrid(tenItem: "bài tập", mota: "Thêm các bài tập luyện", linkImage: "assets/fitness_app/runner.png"),
    ItemGrid(tenItem: "Chế độ ăn uống", mota: "Thêm lịch ăn uống tuần", linkImage: "assets/fitness_app/bento.png"),
    ItemGrid(tenItem: "Chế độ luyện tập", mota: "Thêm các chế độ tập luyện theo tuần", linkImage: "assets/fitness_app/luyentap.png"),
    ItemGrid(tenItem: "Nhắn tin", mota: "Nhắn tin tư vấn cho người dùng", linkImage: "assets/fitness_app/message.png", to: MaterialPageRoute(builder: (context) => SplashScreen())),
  ];

  String url = "";

  Future<void> getAvatar() async{
    var ref = firebase_storage.FirebaseStorage.instance.ref(CurrentUser.currentUser.avatar);
    setState(() async {
      url = await ref.getDownloadURL();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("392950"),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 1/10,),
              Container(
                height: MediaQuery.of(context).size.height * 1/4,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(
                      child: Text(
                        "Xin chào,\n" + (CurrentUser.currentUser.name ?? "").toUpperCase(),
                        style: TextStyle(
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
                        image: backgroundImage,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(url),
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
                            Navigator.push(context, listItems[index].to);
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
                                  style: TextStyle(
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
                                      style: TextStyle(
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