import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/DaLamModel.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/resources/button_quater_circle_back.dart';
import 'package:luan_van/resources/button_quater_circle_next.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/bmi/EvaluateBMIScreen.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:toast/toast.dart';

import '../../main.dart';

class BMIScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BMIScreenState();
}

class BMIScreenState extends State<BMIScreen>{
  var now = DateTime.now();
  double myBorder = 40;
  double mAge = 20;
  double mHeight = CurrentUser.currentUser.height ?? 175;
  double mWeight = CurrentUser.currentUser.weight ?? 60;
  bool isMale = true;

  @override
  void initState() {
    super.initState();
    if(CurrentUser.currentUser.bornYear != null)
      mAge = now.year.roundToDouble() - CurrentUser.currentUser.bornYear;

    if(CurrentUser.currentUser.sex == "Nữ")
      isMale = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Not move screen when show keyboard
      body: Container(
        decoration: new BoxDecoration(image: foodLoadingBackground,),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(myBorder),bottomLeft: Radius.circular(myBorder), topRight:  Radius.circular(myBorder),),
                      ),
                      child: Text(
                        "ĐÁNH GIÁ BMI",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height/7,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(myBorder), bottomRight:  Radius.circular(myBorder),),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chiều cao: " + (mHeight/100).toString() + " m",
                            style: GoogleFonts.quicksand(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),

                          Slider(
                            value: mHeight,
                            onChanged: (newValue){
                              setState(() {
                                mHeight = newValue;
                              });
                            },
                            min: 50,
                            max: 250,
                            divisions: 200,
                            activeColor: Colors.green,
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height/7,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(myBorder), bottomLeft:  Radius.circular(myBorder),),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cân nặng: " + (mWeight.toStringAsFixed(1)).toString() + " kg",
                            style: GoogleFonts.quicksand(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),

                          Slider(
                            value: mWeight,
                            onChanged: (newValue){
                              setState(() {
                                mWeight = newValue;
                              });
                            },
                            min: 30,
                            max: 150,
                            divisions: 600,
                            activeColor: Colors.orange,
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height/7,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(myBorder), bottomRight:  Radius.circular(myBorder),),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (mAge.round()).toString() + " tuổi",
                            style: GoogleFonts.quicksand(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),

                          Slider(
                            value: mAge,
                            onChanged: (newValue){
                              setState(() {
                                mAge = newValue;
                              });
                            },
                            min: 10,
                            max: 70,
                            divisions: 60,
                            activeColor: Colors.purpleAccent,
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height/7,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(myBorder), bottomLeft:  Radius.circular(myBorder),),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isMale ? "Giới tính: Nam" : "Giới tính: Nữ",
                            style: GoogleFonts.quicksand(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  setState(() {
                                    isMale=true;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width/3,
                                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text("Nam",
                                    style: GoogleFonts.quicksand(
                                      color: isMale ? Colors.white : Colors.brown,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMale ? Colors.brown : Colors.grey,
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(40),
                                    )
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap:(){
                                  setState(() {
                                    isMale=false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width/3,
                                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text("Nữ",
                                    style: GoogleFonts.quicksand(
                                      color: !isMale ? Colors.white : Colors.brown,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: !isMale ? Colors.brown : Colors.grey,
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(40),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  GestureDetector(
                    onTap: onNextClick,
                    child: Container(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(myBorder),bottomLeft: Radius.circular(myBorder), bottomRight:  Radius.circular(myBorder),),
                        ),
                        child: Text(
                          Const.KEY_FROM == Const.FROM_HOME ? "LƯU" : "TIẾP TỤC",
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onNextClick() {
    setState(() {
      ProgressLoading().showLoading(context);
        double bmi = getBMI(mWeight, mHeight);
        int age = 2021 - mAge.toInt();
        String male = isMale ? "Name" : "Nữ";
        CurrentUser.currentUser.bmi = bmi;
        CurrentUser.currentUser.height = mHeight;
        CurrentUser.currentUser.weight = mWeight;
        CurrentUser.currentUser.bornYear = age;
        CurrentUser.currentUser.sex = male;

        updateUser(bmi, age, male);
        updateHistoryBMI(bmi, age, male);
    });
  }

  FirebaseFirestore users = FirebaseFirestore.instance;

  Future updateUser(double bmi, int age, String male) async{
    await users.collection('users')
        .doc(CurrentUser.currentUser.id)
        .update(
          {
            'bmi' : bmi,
            'height' : mHeight,
            'weight' : mWeight,
            'bornYear' : age,
            'sex' : male,
          }
        )
        .then((value){
          ProgressLoading().hideLoading(context);
          showDanhGia();

        })
        .catchError((error){
          ProgressLoading().hideLoading(context);
          Toast.show("Đã xảy ra lỗi. Vui lòng thử lại. ", context);
        });
  }

  void showDanhGia(){
    showDialog(
      context: context,
      builder: (_context) =>
          AlertDialog(
            title: Row(
              children: [
                Text("Đánh giá sức khỏe",
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
              ],
            ),
            content: Text(
              getContent(),
              style: GoogleFonts.quicksand(),),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if(Const.KEY_FROM == Const.FROM_HOME) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()),(Route<dynamic> route) => false);
                    Const.KEY_FROM = "";
                  } else Navigator.of(context).push(MaterialPageRoute(builder: (context) => EvaluateBMIScreen()));
                },
                child: Text(Const.KEY_FROM == Const.FROM_HOME ? "Về trang chủ" : "Chọn lịch",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold),),
              ),
            ],
          ),
    );
  }

  String getContent(){
    String content = "";
    if(mHeight>200)
      content += "Bạn khá cao";
    if (mHeight<120 && mAge>=18)
      content += "Bạn khá thấp";
    return evaluateBmiText(CurrentUser.currentUser.bmi) + "\n" + content;
  }

  int evaluateBmiLevel(double BMI){
    String _gender = CurrentUser.currentUser.sex;
    double _BMI = CurrentUser.currentUser.bmi;
    if(_gender == "Nam"){
      if(_BMI < 15) return 1;
      else if(15 <= _BMI && _BMI < 20) return 2;
      else if(20 <= _BMI && _BMI < 25) return 3;
      else if(25 <= _BMI && _BMI < 30) return 4;
      else if(30 <= _BMI) return 5;
    }else{
      if(_BMI < 14) return 1;
      else if(14 <= _BMI && _BMI < 18.5) return 2;
      else if(18.5 <= _BMI && _BMI < 25) return 3;
      else if(25 <= _BMI && _BMI < 30) return 4;
      else if(30 <= _BMI) return 5;
    }
  }

  String evaluateBmiText(double BMI){
    String _evaluateText = "";
    switch(evaluateBmiLevel(BMI)){
      case 1:{
        _evaluateText = "Thiếu cân nghiêm trọng!\nBạn khá là thiếu cân nặng để có cơ thể khỏe mạnh";
      }break;

      case 2:{
        _evaluateText = "Bạn đang thiếu cân!\nBạn cần cải thiện thêm cân nặng để có cơ thể khỏe mạnh";
      }break;
    //Trong chỉ số cơ thể ổn chia nhiều loại.
      case 3:{
        if (BMI>24)    _evaluateText = "Chỉ số cơ thể của bạn khá ổn.\nNhưng sắp đạt mức cân nặng cao";
        else if (BMI<21.5)   _evaluateText = "Chỉ số cơ thể của bạn khá ổn.\nBạn nên tăng cân nhẹ để cho cơ thể khỏe mạnh hơn.";
        else       _evaluateText = "Vóc dáng cân đối\nCần giữ vóc dáng để có cơ thể khỏe mạnh";
      }break;

      case 4:{
        _evaluateText = "Bạn đang thừa cân.\nBạn cần giảm bớt cân nặng để có cơ thể khỏe mạnh hơn.";
      }break;

      case 5:{
        _evaluateText = "Bạn đang bị béo phì!\nBạn khá là thừa cân nặng để có cơ thể khỏe mạnh";
      }break;
    }
    return _evaluateText;
  }

  Future<void> updateHistoryBMI(double bmi, int age, String male) async {
    bool hadData = false;
    String id = "";
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id).collection(Const.COLLECTION_HISTORY_BMI)
        .get().then(
            (value) {
            value.docs.forEach((element) {
              var data = element.data() as Map<String, dynamic>;
              final now = DateTime.now();
              HistoryBMI daLamModel = HistoryBMI.fromJson(data);
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
        luuCoData(id, bmi, age, male);
      } else{
        luuKhongData(bmi, age, male);
      }
    });
  }

  Future<void> luuCoData(String id, double bmi, int age, String male) async {
    HistoryBMI daLamModel = HistoryBMI(
      time: Timestamp.now(),
      height: mHeight,
      weight: mWeight,
      tuoi: age,
      bmi: bmi,
      sex: male
    );
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.COLLECTION_HISTORY_BMI).doc(id).update(daLamModel.toMap());
  }

  Future<void> luuKhongData(double bmi, int age, String male) async {
    HistoryBMI daLamModel = HistoryBMI(
        time: Timestamp.now(),
        height: mHeight,
        weight: mWeight,
        tuoi: age,
        bmi: bmi,
        sex: male
    );
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.COLLECTION_HISTORY_BMI).add(daLamModel.toMap());
  }

  void onBackClick() => Navigator.pop(context);

  double getBMI(var weight, var height_CM){
    var height_M = height_CM/100;
    return weight/(height_M * height_M);
  }
}

