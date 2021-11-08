import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/ScheduleModel.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/schedule/CreateScheduleScreen.dart';
import 'package:luan_van/screens/schedule/MockData.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

final String FROM_BMI = "FROM_BMI";

class MyAppState extends State<MyApp> {
  Future<void> getFoods() async{
    // QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("test").get().then(
            (value){
          value.docs.forEach((element) {
            var data = element.data() as Map<String, dynamic>;
            FoodModel foodModel = FoodModel(
              name: data['name'],
              type: data["type"],
              calo100g: data["calo100g"],
              priority: data["priority"],
              foodImage: data["foodImage"],
              quantity: data["quantity"],
            );
            CurrentUser.listFood.add(foodModel);
            CurrentUser.listFoodString.add(foodModel.name);
          });

        }
    ).whenComplete((){
      ProgressLoading().hideLoading(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleDetailScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    // getFoods();
    if (Const.KEY_FROM == FROM_BMI){
      getSchedule();
    }
  }

  Future<void> getSchedule() async {
    await FirebaseFirestore.instance.collection("schedule").get().then(
      (value){
        value.docs.forEach((element) {
          var data = element.data() as Map<String, dynamic>;
          ScheduleModel scheduleModel = ScheduleModel(
              totalCalo: data["totalCalo"],
              date1: DateMealModel.fromJson(data["date1"]),
              date2: DateMealModel.fromJson(data["date2"]),
              date3: DateMealModel.fromJson(data["date3"]),
              date4: DateMealModel.fromJson(data["date4"]),
              date5: DateMealModel.fromJson(data["date5"]),
              date6: DateMealModel.fromJson(data["date6"]),
              date7: DateMealModel.fromJson(data["date7"]),
          );
          if (data["totalCalo"] == 1500){
            MockData.listMeal2 = [scheduleModel.date1, scheduleModel.date2, scheduleModel.date3, scheduleModel.date4, scheduleModel.date5, scheduleModel.date6, scheduleModel.date7];
            print("---"+MockData.listMeal2[3].id.toString());
            print("---"+MockData.listMeal2[0].caloDate.toString());
          }
          print("---2"+MockData.listMeal2[3].foods[0].name.toString());
        });
      }).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateScheduleScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateScheduleScreen()));
              },
              child: Container(
                height: 100,
                width: 100,
                color: Colors.green,
              ),
            ),

           GestureDetector(
          onTap: (){
            getFoods();
          },
          child: Container(
            height: 100,
            width: 100,
            color: Colors.yellow,
          ),
        ),
          ],
        ),
      ),
    );
  }
}