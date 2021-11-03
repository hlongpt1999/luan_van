import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/resources/button_radius_medium.dart';
import 'package:luan_van/resources/styles.dart';

class ScheduleDetailScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ScheduleDetailScreenState();
  }
}
var _listColorTitle = MyList().listColorTitle;
List<String> bmiNam = [
  "thấp hơn 15 (suy dinh dưỡng)",
  "15 đến dưới 20 (gầy)",
  "20 đến dưới 25 (cân đối)",
  "25 đến dưới 30 (thừa cân)",
  "cao hơn 30 (béo phì)"
];

List<String> bmiNu = [
  "thấp hơn 14 (suy dinh dưỡng)",
  "14 đến dưới 18.5 (gầy)",
  "18.5 đến dưới 25 (cân đối)",
  "25 đến dưới 30 (thừa cân)",
  "cao hơn 30 (béo phì)"
];

List<String> gioiTinh = ["Nam", "Nữ"];
List<String> soLuong = ["100g", "200g", "300g", "400g", "500g", "600g", "700g", "800g", "900g", "1kg"];

final String food = CurrentUser.listFoodString[0];
final double calo = CurrentUser.listFood[0].calo100g;
List<String> foodValue = [food, food, food, food, food, food, food, food, food, food];
List<String> soLuongValue = ["100g","100g","100g","100g","100g","100g","100g","100g","100g","100g"];
List<double> foodNumberCalo = [calo,calo,calo,calo,calo,calo,calo,calo,calo,calo];
List<int> indexFood = [0,0,0,0,0,0,0,0,0,0];
List<int> indexQuanlity = [1,1,1,1,1,1,1,1,1,1];
// List<List<int>> indexQuanlity = [
//   [1,1,1,1,1,1,1,1,1,1],
//   [1,1,1,1,1,1,1,1,1,1]
// ];

int itemLength = 1;

class ScheduleDetailScreenState extends State<ScheduleDetailScreen>{
  double _marginBottom = 30;
  double _marginHor = 10;
  double marginTop = 200;

  String namValue = bmiNam[0];
  String nuValue = bmiNu[0];
  String gioitinhValue = gioiTinh[0];

  String suggestionsSchedule(int calo){
    String text = "";
    switch (calo){
      case 1500:
        text = "150 calo sữa, trứng.\n450 calo thịt, cá.\n450 calo ngũ cốc, tinh bột.\n250 calo rau củ.\n200 calo trái cây.";
        break;
      case 1800:
        text = "180 calo sữa, trứng.\n540 calo thịt, cá.\n540 calo ngũ cốc, tinh bột.\n300 calo rau củ.\n240 calo trái cây.";
        break;
      case 2000:
        text = "200 calo sữa, trứng.\n600 calo thịt, cá.\n600 calo ngũ cốc, tinh bột.\n330 calo rau củ.\n270 calo trái cây.";
        break;
      case 2300:
        text = "230 calo sữa, trứng.\n690 calo thịt, cá.\n690 calo ngũ cốc, tinh bột.\n370 calo rau củ.\n320 calo trái cây.";
        break;
      case 2500:
        text = "250 calo sữa, trứng.\n750 calo thịt, cá.\n750 calo ngũ cốc, tinh bột.\n400 calo rau củ.\n350 calo trái cây.";
        break;
      case 2800:
        text = "280 calo sữa, trứng.\n840 calo thịt, cá.\n840 calo ngũ cốc, tinh bột.\n450 calo rau củ.\n390 calo trái cây.";
        break;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: universalBackground),
        child: Stack(
          children:[
            PageView(
              children: [
                // for (int i=0; i<7 ;i++)
                  ScheduleDetailPage(_listColorTitle[0], (1).toString()),
              ],
            ),

            Container(
              height: marginTop,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueGrey,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Giới tính: "
                        ),

                        DropdownButton(
                          value: gioitinhValue,
                          onChanged: (String data1) {
                            setState(() {
                              gioitinhValue = data1;
                            });
                          },
                          items: gioiTinh.map<DropdownMenuItem<String>>((String value1) {
                            return DropdownMenuItem<String>(
                              value: value1,
                              child: Text(value1),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "BMI: "
                        ),

                        gioitinhValue == "Nam" ?
                        DropdownButton(
                          value: namValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String data) {
                            setState(() {
                              namValue = data;
                            });
                          },
                          items: bmiNam.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ) :
                        DropdownButton(
                          value: nuValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String data) {
                            setState(() {
                              nuValue = data;
                            });
                          },
                          items: bmiNu.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        suggestionsSchedule(1800),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: _marginHor, bottom: _marginBottom),
              alignment: Alignment.bottomLeft,
                child: buttonRadiusMedium("Hủy", Colors.red)
            ),

            GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(right: _marginHor, bottom: _marginBottom),
                  alignment: Alignment.bottomRight,
                  child: buttonRadiusMedium("Lưu", Colors.green)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ScheduleDetailPage(Color _color, String _date){
    var heightDate = 60.0;
    var padding = 40;
    var heightContainer =  MediaQuery.of(context).size.height - marginTop - heightDate/2 - _marginBottom - 50 - padding; //50 là chiều cao button

    Widget itemThucAn(int index){
      return Container(
        child: Row(
          children: [
            SizedBox(width: 10,),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  dropdownColor: Colors.transparent,
                  value: soLuongValue[index],
                  style: TextStyle(color: Colors.white),
                  onChanged: (String data1) {
                    setState(() {
                      soLuongValue[index] = data1;
                      indexQuanlity[index] = soLuong.indexOf(data1)+1;
                      foodNumberCalo[index] = indexQuanlity[index] * CurrentUser.listFood[indexFood[index]].calo100g;
                    });
                  },
                  items: soLuong.map<DropdownMenuItem<String>>((String value1) {
                    return DropdownMenuItem<String>(
                      value: value1,
                      child: Text(value1),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(width: 10,),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.transparent,
                  value: foodValue[index],
                  style: TextStyle(color: Colors.white),
                  onChanged: (String data1) {
                    setState(() {
                      foodValue[index] = data1;
                      indexFood[index] = CurrentUser.listFoodString.indexOf(data1);
                      foodNumberCalo[index] = indexQuanlity[index] * CurrentUser.listFood[indexFood[index]].calo100g;
                    });
                  },
                  items: CurrentUser.listFoodString.map<DropdownMenuItem<String>>((String value1) {
                    return DropdownMenuItem<String>(
                      value: value1,
                      child: Text(value1),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(width: 10,),
            Expanded(
            child:Text(
              foodNumberCalo[index].toString() + " calo",
              style: TextStyle(color: Colors.white),
            ),),
          ],
        ),
      );
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
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i=0; i<itemLength ;i++)
                      itemThucAn(i),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                itemLength++;
                              });
                            },
                            child: Icon(
                              Icons.add
                            ),
                          )
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                itemLength--;
                              });
                            },
                            child: Icon(
                              Icons.minimize
                            ),
                          )
                        ),
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
                child: Container(
                  // padding: EdgeInsets.only(top: 30),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}