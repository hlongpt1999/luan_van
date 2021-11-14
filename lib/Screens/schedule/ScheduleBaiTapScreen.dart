import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
List<String> listGoiY = ["1500 calo","1800 calo","2000 calo","2300 calo","2500 calo","2800 calo"];

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

List<int> itemLength = [1,1,1,1,1,1,1,1,1,1];

class ScheduleBaiTapScreenState extends State<ScheduleBaiTapScreen>{
  double _marginBottom = 30;
  double _marginHor = 10;
  double marginTop = 100;

  String scheduleName = "Mọi đối tượng";
  TextEditingController nameController = TextEditingController();

  String goiYValue = listGoiY[0];
  int totalCalo = 0;
  List<int> totalCaloDate = [0,0,0,0,0,0,0];

  String suggestionsSchedule(String calo){
    String text = "";
    switch (calo){
      case "1500 calo":
        setState(() {
          totalCalo = 1500;
        });
        text = "150 calo sữa, trứng.\n450 calo thịt, cá.\n450 calo ngũ cốc, tinh bột.\n250 calo rau củ.\n200 calo trái cây.";
        break;
      case "1800 calo":
        setState(() {
          totalCalo = 1800;
        });
        text = "180 calo sữa, trứng.\n540 calo thịt, cá.\n540 calo ngũ cốc, tinh bột.\n300 calo rau củ.\n240 calo trái cây.";
        break;
      case "2000 calo":
        setState(() {
          totalCalo = 2000;
        });
        text = "200 calo sữa, trứng.\n600 calo thịt, cá.\n600 calo ngũ cốc, tinh bột.\n330 calo rau củ.\n270 calo trái cây.";
        break;
      case "2300 calo":
        setState(() {
          totalCalo = 2300;
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
      date1.add(CurrentUser.listDongTac[indexFood[0][i]]);
      date1[i].quantity=indexQuanlity[0][i];
    }for (int i=0; i< itemLength[1]; i++){
      date2.add(CurrentUser.listDongTac[indexFood[1][i]]);
      date2[i].quantity=indexQuanlity[1][i];
    }for (int i=0; i< itemLength[2]; i++){
      date3.add(CurrentUser.listDongTac[indexFood[2][i]]);
      date3[i].quantity=indexQuanlity[2][i];
    }for (int i=0; i< itemLength[3]; i++){
      date4.add(CurrentUser.listDongTac[indexFood[3][i]]);
      date4[i].quantity=indexQuanlity[3][i];
    }for (int i=0; i< itemLength[4]; i++){
      date5.add(CurrentUser.listDongTac[indexFood[4][i]]);
      date5[i].quantity=indexQuanlity[4][i];
    }for (int i=0; i< itemLength[5]; i++){
      date6.add(CurrentUser.listDongTac[indexFood[5][i]]);
      date6[i].quantity=indexQuanlity[5][i];
    }for (int i=0; i< itemLength[6]; i++){
      date7.add(CurrentUser.listDongTac[indexFood[6][i]]);
      date7[i].quantity=indexQuanlity[6][i];
    }

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection(Const.CSDL_SCHEDULE_LUYENTAP).add(
        {
          'name' : scheduleName,
          'totalCalo' : totalCalo,
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
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Luyện tập tiêu thụ: ",
                        style: TextStyle(
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
                              child: Text(value1, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
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
                      style: TextStyle(
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
        foodNumberCalo[i][index] = (indexQuanlity[i][index] * CurrentUser.listDongTac[indexFood[i][index]].caloLost100g)/100;
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
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(width: 10,),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.transparent,
                      value: foodValue[i][index],
                      style: TextStyle(color: Colors.white),
                      onChanged: (String data1) {
                        setState(() {
                          foodValue[i][index] = data1;
                          indexFood[i][index] = CurrentUser.listDongTacString.indexOf(data1);
                          foodNumberCalo[i][index] = (indexQuanlity[i][index] * CurrentUser.listDongTac[indexFood[i][index]].caloLost100g)/100;
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

                SizedBox(width: 10,),
                Expanded(
                  child:Text(
                      foodNumberCalo[i][index].round().toString()=="0" ?
                      foodNumberCalo[i][index].round().toString() + " calo" :
                    "-"+foodNumberCalo[i][index].round().toString() + " calo",
                    style: TextStyle(color: Colors.white),
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
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              style: TextStyle(
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
                                              child: Text("Lưu tên"),
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
                                style: TextStyle(
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
                          style: TextStyle(
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
}