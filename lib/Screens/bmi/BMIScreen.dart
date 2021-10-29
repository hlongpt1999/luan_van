import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/resources/button_quater_circle_back.dart';
import 'package:luan_van/resources/button_quater_circle_next.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/bmi/EvaluateBMIScreen.dart';
import 'package:toast/toast.dart';

import '../../main.dart';

class BMIScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BMIScreenState();
}

class BMIScreenState extends State<BMIScreen>{
  double myBorder = 40;
  double mAge = 20, mHeight = 175, mWeight = 60;
  bool isMale = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Not move screen when show keyboard
      body: Container(
        decoration: new BoxDecoration(image: bmiBackground,),
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
                        style: TextStyle(
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
                            style: TextStyle(
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
                            style: TextStyle(
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
                            style: TextStyle(
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
                            style: TextStyle(
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
                                    style: TextStyle(
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
                                    style: TextStyle(
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
                          "TIẾP TỤC",
                          style: TextStyle(
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EvaluateBMIScreen()));
        })
        .catchError((error){
          ProgressLoading().hideLoading(context);
          Toast.show("Đã xảy ra lỗi. Vui lòng thử lại. ", context);
        });
  }

  void onBackClick() => Navigator.pop(context);

  double getBMI(var weight, var height_CM){
    var height_M = height_CM/100;
    return weight/(height_M * height_M);
  }
}

