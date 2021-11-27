import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/DaLamModel.dart';
import 'package:luan_van/resources/button_circle_max.dart';
import 'package:luan_van/screens/home/components/DietListView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabDanhGiaScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TabDanhGiaStateScreen();
}

class TabDanhGiaStateScreen extends State<TabDanhGiaScreen>{
  List<TextEditingController> soLuongController =
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),
    TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),
    TextEditingController(),TextEditingController()];

  List<TextEditingController> soLuongLuyenTapController =
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),
    TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),
    TextEditingController(),TextEditingController()];

  double tongHapThu = 0, tongDotChay = 0;

  Future<void> getDataDaLam() async{
    List<String> listPrefData = [];

    SharedPreferences pref = await  SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String today = DateFormat("dd/M/yyyy").format(now);
    listPrefData = pref.getStringList(today+"DG");

    if(listPrefData==null || listPrefData.length == 0 || listPrefData.isEmpty){
      for(int i=0; i<10;i++){
        soLuongController[i].text = "0";
        soLuongLuyenTapController[i].text = "0";
      }
    } else {
      for(int i=0; i<CurrentUser.listFood.length;i++){
        setState(() {
          soLuongController[i].text = listPrefData[i];
        });
      }
      for(int i=0; i<CurrentUser.listDongTac.length;i++){
        setState(() {
          soLuongLuyenTapController[i].text = listPrefData[i+CurrentUser.listFood.length];
        });
      }
    }

    updateCalo();
  }

  @override
  void initState(){
    super.initState();
    getDataDaLam();
  }

  Future<void> luuDaLamVaoPref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String today = DateFormat("dd/M/yyyy").format(now);
    List<String> listPrefData =[];
    for(int i=0;i<CurrentUser.listFood.length;i++){
      if (soLuongController[i].text == null || soLuongController[i].text == "")
        listPrefData.add("0");
      else listPrefData.add(soLuongController[i].text);
    }
    for(int i=0;i<CurrentUser.listDongTac.length;i++){
      if (soLuongLuyenTapController[i].text == null || soLuongLuyenTapController[i].text == "")
        listPrefData.add("0");
      else listPrefData.add(soLuongLuyenTapController[i].text);
    }
    pref.setStringList(today+"DG", listPrefData);
  }

  Future<void> luuDaLamLenCSDL() async {
    bool hadData = false;
    String id = "";
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id).collection(Const.COLLECTION_DALAM)
        .get().then(
      (value) {
        value.docs.forEach((element) {
          var data = element.data() as Map<String, dynamic>;
          final now = DateTime.now();
          DaLamModel daLamModel = DaLamModel.fromJson(data);
          if(daLamModel.time.toDate().year == now.year
          && daLamModel.time.toDate().month == now.month
          && daLamModel.time.toDate().day == now.day){
            hadData = true;
            id = element.id;
          }
        });
      }
    ).whenComplete((){
      if(hadData){
        luuCoData(id);
      } else{
        luuKhongData();
      }
    });
  }
  
  void showThongBao(){
    showDialog(
      context: context,
      builder: (_context)=> AlertDialog(
        title: Text("Thông báo",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
        content: Text("Đã lưu thành công. Bạn có thể cập nhật nếu muốn.",
          style: GoogleFonts.quicksand(),),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Đã hiểu",
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }

  Future<void> luuCoData(String id) async {
    DaLamModel daLamModel = DaLamModel(
      time: Timestamp.now(),
      totalFoodCalo: tongHapThu,
      totalDongTacCalo: tongDotChay,
      caloFoodDate: CurrentUser.totalCaloDate,
      caloDongTacDate: CurrentUser.totalCaloDateLost,
    );
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.COLLECTION_DALAM).doc(id).update(daLamModel.toMap()).whenComplete(() => showThongBao());
  }

  Future<void> luuKhongData() async {
    DaLamModel daLamModel = DaLamModel(
      time: Timestamp.now(),
      totalFoodCalo: tongHapThu,
      totalDongTacCalo: tongDotChay,
      caloFoodDate: CurrentUser.totalCaloDate,
      caloDongTacDate: CurrentUser.totalCaloDateLost,
    );
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.COLLECTION_DALAM).add(daLamModel.toMap()).whenComplete(() => showThongBao());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.colorBackgroundTab,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[900],
                        Colors.blue[700],
                        Colors.blue[500],
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    "Hôm nay đã thực hiện ",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),

                    Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chế độ ăn uống:",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    for (int i=0; i<CurrentUser.listFood.length ;i++)
                      itemDanhGia(i),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
                      child: Row(
                        children: [
                          Text(
                            "Đã hấp thu:",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),

                          SizedBox(width: 10,),

                          Text(
                            tongHapThu.round().toString() + "/"+CurrentUser.totalCaloDate.toString() + "Calo",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),

                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),

                    Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chế độ luyện tập:",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    for (int i=0; i<CurrentUser.listDongTac.length ;i++)
                      itemDanhGiaLuyenTap(i),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
                      child: Row(
                        children: [
                          Text(
                            "Đã đốt cháy:",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),

                          SizedBox(width: 10,),

                          Flexible(
                            child: Wrap(
                              children: [
                                Text(
                                  tongDotChay.round().toString() + "/"+CurrentUser.totalCaloDateLost.toString() + "Calo",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),
                   ],
                ),
              ),

              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  luuDaLamVaoPref();
                  luuDaLamLenCSDL();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange[900],
                        Colors.orange[700],
                        Colors.orange[500],
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        size: 25,
                        color: Colors.white,
                      ),

                      SizedBox(width: 10,),

                      Text(
                        "Lưu",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),

        ),
      ),
    );
  }

  updateCalo(){
    bool hopLe = true;
    for (int i =0;i<10;i++){
      if (soLuongController[i].text != null && soLuongController[i].text != "")
      if(int.parse(soLuongController[i].text) > 3000){
        hopLe = false;
        setState(() {
          soLuongController[i].text = "3000";
        });
      }
      if (soLuongLuyenTapController[i].text != null && soLuongLuyenTapController[i].text != "")
      if(int.parse(soLuongLuyenTapController[i].text) > 3000){
        hopLe = false;
        setState(() {
          soLuongLuyenTapController[i].text = "3000";
        });
      }
    }

    if(!hopLe){
      showDialog(
        context: context,
        builder: (_context)=> AlertDialog(
          title: Text("Thông báo",
            style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
          ),
          content: Text("Số lượng không hợp lệ.\nTối đa 3kg mỗi loại thực phẩm. Tối đa 3000 lần mỗi động tác",
            style: GoogleFonts.quicksand(),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đã hiểu",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      );
    }

    setState(() {
      double hapThu=0, dotChay=0;

      for (int i =0;i<CurrentUser.listFood.length;i++){
        if (soLuongController[i].text != null && soLuongController[i].text != "")
          hapThu += ((int.parse(soLuongController[i].text.toString()))/100 * CurrentUser.listFood[i].quantity);
      }
      for (int i =0;i<CurrentUser.listDongTac.length;i++){
        if (soLuongLuyenTapController[i].text != null && soLuongLuyenTapController[i].text != "")
          dotChay += ((int.parse(soLuongLuyenTapController[i].text.toString()))/100 * CurrentUser.listDongTac[i].quantity);
      }

      tongDotChay=dotChay;
      tongHapThu=hapThu;
    });
  }

  Widget itemDanhGia(int index){
    return Container(
      child: Row(
        children: [
          SizedBox(width: 10,),
          Container(
            width: 70,
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (String text){
                updateCalo();
              },
              controller: soLuongController[index],
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "gam",
                hintStyle: GoogleFonts.quicksand(
                  color: Colors.grey,
                ),
              ),
              style: GoogleFonts.quicksand(
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(width: 10,),

          Text(
            CurrentUser.listFood[index].name,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDanhGiaLuyenTap(int index){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10,),
          Container(
            width: 70,
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (String text) async{
                updateCalo();
              },
              controller: soLuongLuyenTapController[index],
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: CurrentUser.listDongTac[index].donvi ?? "lần",
                hintStyle: GoogleFonts.quicksand(
                  color: Colors.grey,
                ),
              ),
              style: GoogleFonts.quicksand(
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(width: 10,),

          Text(
            CurrentUser.listDongTac[index].name,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}