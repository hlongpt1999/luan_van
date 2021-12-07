import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/Method.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/DateLuyenTapModel.dart';
import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/MovementModel.dart';
import 'package:luan_van/model/ScheduleModel.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/schedule/CreateScheduleScreen.dart';
import 'package:luan_van/screens/schedule/MockData.dart';
import 'package:luan_van/screens/schedule/ScheduleBaiTapScreen.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Future<void> getFoods() async{
    CurrentUser.listFood.clear();
    CurrentUser.listFoodString.clear();
    await FirebaseFirestore.instance.collection(Const.CSDL_FOODS).get().then(
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

  Future<void> getBaiTap() async{
    CurrentUser.listDongTac.clear();
    CurrentUser.listDongTacString.clear();
    await FirebaseFirestore.instance.collection(Const.CSDL_DONGTAC).get().then(
            (value){
          value.docs.forEach((element) {
            var data = element.data() as Map<String, dynamic>;
            MovementModel movementModel = MovementModel.fromJson(data);
            CurrentUser.listDongTac.add(movementModel);
            CurrentUser.listDongTacString.add(movementModel.name);
          });

        }
    ).whenComplete((){
      ProgressLoading().hideLoading(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleBaiTapScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if(Const.KEY_FROM == Const.FROM_BMI){
        getToSchedule();
      } else if (Const.KEY_FROM == Const.FROM_CREATE_SCHEDULE){
        getFoods();
      } else if (Const.KEY_FROM == Const.FROM_CREATE_SCHEDULE_LUYENTAP){
        getBaiTap();
      } else if (Const.KEY_FROM == Const.FROM_SCHEDULE){
        getSchedule(CurrentUser.currentUser.id, context);
      }
    });
  }

  Future<void> getToSchedule() async {
    MockData.listMeal2 = [];
    await FirebaseFirestore.instance.collection(Const.CSDL_LICH).get().then(
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
            name: data["name"] ?? "Mọi đối tượng",
          );
          if (data["totalCalo"] == CurrentUser.goiCalo){
            MockData.listMeal2 = [scheduleModel.date1, scheduleModel.date2, scheduleModel.date3, scheduleModel.date4, scheduleModel.date5, scheduleModel.date6, scheduleModel.date7];
          }
        });
      }).whenComplete(() => getToScheduleLuyenTap());
  }

  Future<void> getToScheduleLuyenTap() async {
    MockData.listLuyenTap = [];
    await FirebaseFirestore.instance.collection(Const.CSDL_SCHEDULE_LUYENTAP).get().then(
            (value){
          value.docs.forEach((element) {
            var data = element.data() as Map<String, dynamic>;
            ScheduleLuyenTapModel scheduleModel = ScheduleLuyenTapModel(
              totalCalo: data["totalCalo"],
              date1: DateLuyenTapModel.fromJson(data["date1"]),
              date2: DateLuyenTapModel.fromJson(data["date2"]),
              date3: DateLuyenTapModel.fromJson(data["date3"]),
              date4: DateLuyenTapModel.fromJson(data["date4"]),
              date5: DateLuyenTapModel.fromJson(data["date5"]),
              date6: DateLuyenTapModel.fromJson(data["date6"]),
              date7: DateLuyenTapModel.fromJson(data["date7"]),
              name: data["name"] ?? "Mọi đối tượng",
            );
            if (data["totalCalo"] == CurrentUser.goiCalo){
              MockData.listLuyenTap = [scheduleModel.date1, scheduleModel.date2, scheduleModel.date3, scheduleModel.date4, scheduleModel.date5, scheduleModel.date6, scheduleModel.date7];
            }

            print("HÈ HE");
          });
        }).whenComplete(()
    => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateScheduleScreen()))
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: Const.KEY_FROM == Const.FROM_CREATE_SCHEDULE_LUYENTAP ? gymBackground : foodLoadingBackground,
        ),
        child: Container(
          height: 60,
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 15,),

              SpinKitSpinningLines(
                color: HexColor("392950"),
                size: 40.0,
              ),

              SizedBox(width: 15,),

              Text("Đang tải ...",
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  color: HexColor("392950"),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 15,),
            ],
          ),
        ),
      ),
    );
  }
}