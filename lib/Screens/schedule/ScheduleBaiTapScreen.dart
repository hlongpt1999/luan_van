import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/DateLuyenTapModel.dart';
import 'package:luan_van/model/DateLuyenTapModel.dart';
import 'package:luan_van/model/MovementModel.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/resources/button_radius_medium.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ScheduleBaiTapScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ScheduleBaiTapScreenState();
  }
}

var _listColorTitle = MyList().listColorTitle;
List<String> listGoiY = ["800 calo","1000 calo","1300 calo","1500 calo"];

final String food = CurrentUser.listDongTacString[0];
final double calo = 0;

List<List<String>> foodValue = [
  [food, food, food, food, food, food, food, food, food, food],
  [food, food, food, food, food, food, food, food, food, food],
  [food, food, food, food, food, food, food, food, food, food],
  [food, food, food, food, food, food, food, food, food, food],
  [food, food, food, food, food, food, food, food, food, food],
  [food, food, food, food, food, food, food, food, food, food],
  [food, food, food, food, food, food, food, food, food, food]
];

List<List<TextEditingController>> soLuongController = [
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()],
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()],
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()],
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()],
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()],
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()],
  [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()]
];

List<List<double>> foodNumberCalo = [
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo],
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo],
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo],
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo],
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo],
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo],
  [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo]
];

List<List<int>> indexFood = [
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0]
];

List<List<int>> indexQuanlity = [
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0]
];

List<int> itemLength = [1,1,1,1,1,1,1];

class ScheduleBaiTapScreenState extends State<ScheduleBaiTapScreen>{
  double _marginBottom = 30;
  double _marginHor = 10;
  double marginTop = 200;

  String scheduleName = "Mọi đối tượng";
  TextEditingController nameController = TextEditingController();

  String goiYValue = listGoiY[0];
  int totalCalo = 800;
  List<int> totalCaloDate = [0,0,0,0,0,0,0];

  final List<String> listGioiTinh = ["Nam và nữ", "Nam", "Nữ"];
  String gioiTinh =  "Nam và nữ";

  final List<String> listTuoi = ["10", "15", "20","25","30","35","40","45","50","55","60","65","70",];
  String minTuoi = "10";
  String maxTuoi = "70";

  Future<void> uploadSchedule() async{
    ProgressLoading().showLoading(context);
    List<MovementModel> date1= [];
    List<MovementModel> date2= [];
    List<MovementModel> date3= [];
    List<MovementModel> date4= [];
    List<MovementModel> date5= [];
    List<MovementModel> date6= [];
    List<MovementModel> date7= [];
    for (int i=0; i< itemLength[0]; i++){
      MovementModel model = new MovementModel(
        idMovement: CurrentUser.listDongTac[indexFood[0][i]].idMovement,
        name: CurrentUser.listDongTac[indexFood[0][i]].name,
        detail: CurrentUser.listDongTac[indexFood[0][i]].detail,
        caloLost100g: CurrentUser.listDongTac[indexFood[0][i]].caloLost100g,
        type: CurrentUser.listDongTac[indexFood[0][i]].type,
        link: CurrentUser.listDongTac[indexFood[0][i]].link,
        donvi:  CurrentUser.listDongTac[indexFood[0][i]].donvi,
        quantity: int.parse(soLuongController[0][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[0][i]].imageDetail,
    );
      date1.add(model);
    }
    for (int i=0; i< itemLength[1]; i++){
      MovementModel model = new MovementModel(
        idMovement: CurrentUser.listDongTac[indexFood[1][i]].idMovement,
        name: CurrentUser.listDongTac[indexFood[1][i]].name,
        detail: CurrentUser.listDongTac[indexFood[1][i]].detail,
        caloLost100g: CurrentUser.listDongTac[indexFood[1][i]].caloLost100g,
        type: CurrentUser.listDongTac[indexFood[1][i]].type,
        link: CurrentUser.listDongTac[indexFood[1][i]].link,
        donvi:  CurrentUser.listDongTac[indexFood[1][i]].donvi,
        quantity: int.parse(soLuongController[1][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[1][i]].imageDetail,
      );
      date2.add(model);
    }for (int i=0; i< itemLength[2]; i++){
      MovementModel model = new MovementModel(
          idMovement: CurrentUser.listDongTac[indexFood[2][i]].idMovement,
          name: CurrentUser.listDongTac[indexFood[2][i]].name,
          detail: CurrentUser.listDongTac[indexFood[2][i]].detail,
          caloLost100g: CurrentUser.listDongTac[indexFood[2][i]].caloLost100g,
          type: CurrentUser.listDongTac[indexFood[2][i]].type,
          link: CurrentUser.listDongTac[indexFood[2][i]].link,
          donvi:  CurrentUser.listDongTac[indexFood[2][i]].donvi,
          quantity: int.parse(soLuongController[2][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[2][i]].imageDetail,
      );
      date3.add(model);
    }for (int i=0; i< itemLength[3]; i++){
      MovementModel model = new MovementModel(
          idMovement: CurrentUser.listDongTac[indexFood[3][i]].idMovement,
          name: CurrentUser.listDongTac[indexFood[3][i]].name,
          detail: CurrentUser.listDongTac[indexFood[3][i]].detail,
          caloLost100g: CurrentUser.listDongTac[indexFood[3][i]].caloLost100g,
          type: CurrentUser.listDongTac[indexFood[3][i]].type,
          link: CurrentUser.listDongTac[indexFood[3][i]].link,
          donvi:  CurrentUser.listDongTac[indexFood[3][i]].donvi,
          quantity: int.parse(soLuongController[3][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[3][i]].imageDetail,
      );
      date4.add(model);
    }for (int i=0; i< itemLength[4]; i++){
      MovementModel model = new MovementModel(
          idMovement: CurrentUser.listDongTac[indexFood[4][i]].idMovement,
          name: CurrentUser.listDongTac[indexFood[4][i]].name,
          detail: CurrentUser.listDongTac[indexFood[4][i]].detail,
          caloLost100g: CurrentUser.listDongTac[indexFood[4][i]].caloLost100g,
          type: CurrentUser.listDongTac[indexFood[4][i]].type,
          link: CurrentUser.listDongTac[indexFood[4][i]].link,
          donvi:  CurrentUser.listDongTac[indexFood[4][i]].donvi,
          quantity: int.parse(soLuongController[4][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[4][i]].imageDetail,
      );
      date5.add(model);
    }for (int i=0; i< itemLength[5]; i++){
      MovementModel model = new MovementModel(
          idMovement: CurrentUser.listDongTac[indexFood[5][i]].idMovement,
          name: CurrentUser.listDongTac[indexFood[5][i]].name,
          detail: CurrentUser.listDongTac[indexFood[5][i]].detail,
          caloLost100g: CurrentUser.listDongTac[indexFood[5][i]].caloLost100g,
          type: CurrentUser.listDongTac[indexFood[5][i]].type,
          link: CurrentUser.listDongTac[indexFood[5][i]].link,
          donvi:  CurrentUser.listDongTac[indexFood[5][i]].donvi,
          quantity: int.parse(soLuongController[5][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[5][i]].imageDetail,
      );
      date6.add(model);
    }for (int i=0; i< itemLength[6]; i++){
      MovementModel model = new MovementModel(
          idMovement: CurrentUser.listDongTac[indexFood[6][i]].idMovement,
          name: CurrentUser.listDongTac[indexFood[6][i]].name,
          detail: CurrentUser.listDongTac[indexFood[6][i]].detail,
          caloLost100g: CurrentUser.listDongTac[indexFood[6][i]].caloLost100g,
          type: CurrentUser.listDongTac[indexFood[6][i]].type,
          link: CurrentUser.listDongTac[indexFood[6][i]].link,
          donvi:  CurrentUser.listDongTac[indexFood[6][i]].donvi,
          quantity: int.parse(soLuongController[6][i].text.toString()),
        imageDetail: CurrentUser.listDongTac[indexFood[6][i]].imageDetail,
      );
      date7.add(model);
    }

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection(Const.CSDL_SCHEDULE_LUYENTAP).add(
        {
          'name' : scheduleName,
          'totalCalo' : totalCalo,
          'gioiTinh' : gioiTinh,
          'minTuoi' : int.parse(minTuoi),
          'maxTuoi' : int.parse(maxTuoi),
          'date1' : DateLuyenTapModel(
            id: 1,
            caloDate: totalCaloDate[0],
            dongTac: date1,
          ).toMap(),
          'date2' : DateLuyenTapModel(
            id: 2,
            caloDate: totalCaloDate[1],
            dongTac: date2,
          ).toMap(),
          'date3' : DateLuyenTapModel(
            id: 3,
            caloDate: totalCaloDate[2],
            dongTac: date3,
          ).toMap(),
          'date4' : DateLuyenTapModel(
            id: 4,
            caloDate: totalCaloDate[3],
            dongTac: date4,
          ).toMap(),
          'date5' : DateLuyenTapModel(
            id: 5,
            caloDate: totalCaloDate[4],
            dongTac: date5,
          ).toMap(),
          'date6' : DateLuyenTapModel(
            id: 6,
            caloDate: totalCaloDate[5],
            dongTac: date6,
          ).toMap(),
          'date7' : DateLuyenTapModel(
            id: 7,
            caloDate: totalCaloDate[6],
            dongTac: date7,
          ).toMap(),
        }
    ).then((value){
      Toast.show("Đã thêm lịch luyện tập thành công", context);
    }).catchError((error) => print("Lỗi khi thêm: $error")).whenComplete(() {
      ProgressLoading().hideLoading(context);
      Navigator.of(context).pop();
    });
  }

  bool isNull(){
    for(int i=0;i<7;i++)
      for(int j=0;j<itemLength[i];j++){
        if(soLuongController[i][j].text=="" || int.parse(soLuongController[i][j].text)<=0)
          return true;
      }
    return false;
  }

  bool isOutOfCalo(){
    for(int i=0;i<7;i++)
      if(totalCaloDate[i]<=(totalCalo*0.9) || totalCaloDate[i]>=(totalCalo*1.1))
        return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(image: gymBackground),
        child: Stack(
          children:[
            PageView(
              children: [
                for (int i=0; i<7 ;i++)
                  ScheduleDetailPage(_listColorTitle[i], (i+1).toString(), i),
              ],
            ),

            Container(
              height: marginTop,
              width: double.infinity,
              padding: EdgeInsets.only(top: 35, right: 10, left: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HexColor("392950"),
                    Colors.purple,
                    Colors.purpleAccent,
                  ],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      Text(
                        "Dành cho giới tính: ",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          dropdownColor: Colors.transparent,
                          value: gioiTinh,
                          onChanged: (String data1) {
                            setState(() {
                              gioiTinh = data1;
                            });
                          },
                          items: listGioiTinh.map<DropdownMenuItem<String>>((String value1) {
                            return DropdownMenuItem<String>(
                              value: value1,
                              child: Text(value1, style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      Text(
                        "Độ tuổi: ",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          dropdownColor: Colors.transparent,
                          value: minTuoi,
                          onChanged: (String data1) {
                            setState(() {
                              minTuoi = data1;
                            });
                          },
                          items: listTuoi.map<DropdownMenuItem<String>>((String value1) {
                            return DropdownMenuItem<String>(
                              value: value1,
                              child: Text(value1, style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                            );
                          }).toList(),
                        ),
                      ),

                      Text(
                        " đến   ",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          dropdownColor: Colors.transparent,
                          value: maxTuoi,
                          onChanged: (String data1) {
                            setState(() {
                              maxTuoi = data1;
                            });
                          },
                          items: listTuoi.map<DropdownMenuItem<String>>((String value1) {
                            return DropdownMenuItem<String>(
                              value: value1,
                              child: Text(value1, style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 30,),
                      Text(
                        "Luyện tập tiêu thụ: ",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          dropdownColor: Colors.transparent,
                          value: goiYValue,
                          onChanged: (String data1) {
                            setState(() {
                              goiYValue = data1;
                              suggestionsSchedule(data1);
                            });
                          },
                          items: listGoiY.map<DropdownMenuItem<String>>((String value1) {
                            return DropdownMenuItem<String>(
                              value: value1,
                              child: Text(value1, style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: (){
                if (isNull())
                  Toast.show("Vui lòng nhập các giá trị hợp lệ", context);
                else if (isOutOfCalo())
                  Toast.show("Có ngày tiêu hao không đủ calo", context);
                else
                  uploadSchedule();
              },
              child: Container(
                padding: EdgeInsets.only(bottom: _marginBottom),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.purple[200],
                        Colors.white30,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 7,
                        blurRadius: 10,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Lưu lịch tập luyện",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ScheduleDetailPage(Color _color, String _date, int i){
    var heightDate = 60.0;
    var padding = 40;
    var heightContainer =  MediaQuery.of(context).size.height - marginTop - heightDate/2 - _marginBottom - 50 - padding; //50 là chiều cao button

    void updateCalo(String text, int index){
      setState(() {
        indexQuanlity[i][index] = text.isEmpty ? 0 : int.parse(text);
        foodNumberCalo[i][index] = (indexQuanlity[i][index] * CurrentUser.listDongTac[indexFood[i][index]].caloLost100g);
      });
    }

    Widget itemThucAn(int index){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3* MySize.paddingHor),
            child: Container(
              height: 0.5,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                SizedBox(width: 10,),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (String text) async{
                      updateCalo(text, index);
                    },
                    controller: soLuongController[i][index],
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "lần",
                      hintStyle: GoogleFonts.quicksand(
                        color: Colors.grey,
                      ),
                    ),
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(width: 4,),
                Container(
                  width: MediaQuery.of(context).size.width*0.8/2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.transparent,
                      value: foodValue[i][index],
                      style: GoogleFonts.quicksand(color: Colors.white),
                      onChanged: (String data1) {
                        setState(() {
                          foodValue[i][index] = data1;
                          indexFood[i][index] = CurrentUser.listDongTacString.indexOf(data1);
                          foodNumberCalo[i][index] = (indexQuanlity[i][index] * CurrentUser.listDongTac[indexFood[i][index]].caloLost100g);
                        });
                      },
                      items: CurrentUser.listDongTacString.map<DropdownMenuItem<String>>((String value1) {
                        return DropdownMenuItem<String>(
                          value: value1,
                          child: Text(value1.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(width: 4,),
                Expanded(
                  child:Text(
                      foodNumberCalo[i][index].round().toString()=="0" ?
                      foodNumberCalo[i][index].round().toString() + " calo" :
                    "-"+foodNumberCalo[i][index].round().toString() + " calo",
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13),
                  ),),
              ],
            ),
          ),
        ],
      );
    }

    double getTotalCalo(){
      double total = 0;
      for (int a=0; a<itemLength[i];a++){
        total = total + foodNumberCalo[i][a];
      }
      setState(() {
        totalCaloDate[i]=total.round();
      });
      return total;
    }

    return Container(
      padding: EdgeInsets.only(top: marginTop + padding/2, bottom: _marginBottom + 50),
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: heightDate, bottom: 10),
              height: heightContainer,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: HexColor("392950"),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int a=0; a<itemLength[i] ;a++)
                      itemThucAn(a),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        SizedBox(width: 10,),

                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(itemLength[i]<10)  itemLength[i]++;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(itemLength[i]>1) itemLength[i]--;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Text(
                              getTotalCalo().round().toString() =="0"?
                              getTotalCalo().round().toString()+ " calo":
                            "-"+getTotalCalo().round().toString()+ " calo",
                            style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),

                        SizedBox(width: 10,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: heightDate+10, right: 5),
                      height: heightDate,
                      width: 240,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(180)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  context: context,
                                  builder: (BuildContext context){
                                    return Padding(
                                      padding: MediaQuery.of(context).viewInsets,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: HexColor("392950"),
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextField(
                                              autofocus: true,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.text,
                                              controller: nameController,
                                              textCapitalization: TextCapitalization.sentences,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder.none,
                                                hintText: "Nhập tên lịch tập luyện",
                                                hintStyle: GoogleFonts.quicksand(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 19,
                                              ),
                                            ),

                                            ElevatedButton(
                                              onPressed: (){
                                                setState(() {
                                                  scheduleName = nameController.text;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text("Lưu tên", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );

                              setState(() {
                                nameController.text = scheduleName;
                              });
                            },
                            child: Flexible(
                              child: Text(
                                scheduleName,
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          scheduleName!="Mọi đối tượng"
                              ? GestureDetector(
                            onTap: (){
                              setState(() {
                                scheduleName="Mọi đối tượng";
                              });
                            },
                            child: Icon(
                              Icons.refresh,
                              color: Colors.black,
                              size: 25,
                            ),
                          )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),

                    Container(
                      height: heightDate,
                      width: heightDate,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(180)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            spreadRadius: 7,
                            blurRadius: 10,
                            offset: Offset(1, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _date,
                          style: GoogleFonts.quicksand(
                            color: _color,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  String suggestionsSchedule(String calo){
    String text = "";
    switch (calo){
      case "1500 calo":
        setState(() {
          totalCalo = 1500;
        });
        text = "150 calo sữa, trứng.\n450 calo thịt, cá.\n450 calo ngũ cốc, tinh bột.\n250 calo rau củ.\n200 calo trái cây.";
        break;
      case "800 calo":
        setState(() {
          totalCalo = 800;
        });
        text = "180 calo sữa, trứng.\n540 calo thịt, cá.\n540 calo ngũ cốc, tinh bột.\n300 calo rau củ.\n240 calo trái cây.";
        break;
      case "1000 calo":
        setState(() {
          totalCalo = 1000;
        });
        text = "200 calo sữa, trứng.\n600 calo thịt, cá.\n600 calo ngũ cốc, tinh bột.\n330 calo rau củ.\n270 calo trái cây.";
        break;
      case "1300 calo":
        setState(() {
          totalCalo = 1300;
        });
        text = "230 calo sữa, trứng.\n690 calo thịt, cá.\n690 calo ngũ cốc, tinh bột.\n370 calo rau củ.\n320 calo trái cây.";
        break;
      case "2500 calo":
        setState(() {
          totalCalo = 2500;
        });
        text = "250 calo sữa, trứng.\n750 calo thịt, cá.\n750 calo ngũ cốc, tinh bột.\n400 calo rau củ.\n350 calo trái cây.";
        break;
      case "2800 calo":
        setState(() {
          totalCalo = 2800;
        });
        text = "280 calo sữa, trứng.\n840 calo thịt, cá.\n840 calo ngũ cốc, tinh bột.\n450 calo rau củ.\n390 calo trái cây.";
        break;
    }
    return text;
  }
}