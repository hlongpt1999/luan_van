import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/ChatModel.dart';
import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/schedule/MockData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> getSchedule(String idUser, BuildContext _context) async{
  MockData.listMeal2 = [];
  await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(idUser).collection("schedule").get().then(
          (value){
        value.docs.forEach((element) async {
          var data = element.data() as Map<String, dynamic>;
          final now = DateTime.now();
          DateMealModel dateMealModel = new DateMealModel.fromJson(data);
          for(int i=0; i<7;i++){
            if(dateMealModel.time.toDate().day== now.day + i &&
                dateMealModel.time.toDate().month == now.month &&
                  dateMealModel.time.toDate().year == now.year){
              MockData.listMeal2.add(dateMealModel);
            }
          }
        });
      }
  ).whenComplete(() async {
    for (int j=0 ; j<MockData.listMeal2.length-1;j++)
      for (int k=j+1; k <MockData.listMeal2.length;k++){
        if(MockData.listMeal2[j].time.millisecondsSinceEpoch > MockData.listMeal2[k].time.millisecondsSinceEpoch ){
          DateMealModel temp = MockData.listMeal2[j];
          MockData.listMeal2[j] = MockData.listMeal2[k];
          MockData.listMeal2[k] = temp;
        }
    }
    List<DateMealModel> _listMeal = MockData.listMeal2;
    //TODO: ID_NUMER 1
    List<String> foodName=[];
    SharedPreferences pref = await SharedPreferences.getInstance();
    for (var i = 0; i<7; i++){
      for (var j=0; j<_listMeal[i].foods.length ; j++){
        foodName.add(_listMeal[i].foods[j].name);
        var ref = firebase_storage.FirebaseStorage.instance
            .ref(_listMeal[i].foods[j].foodImage);
        String avatar = await ref.getDownloadURL();
        //Lưu dữ liệu món ăn (Theo thứ tự lần lượt là: 0- Calo, 1- quanlity , 2-LinkdownfoodImage,
        pref.setStringList(_listMeal[i].foods[j].name,
            [
              _listMeal[i].foods[j].calo100g.toString(),
              _listMeal[i].foods[j].quantity.toString(),
              avatar
            ]);
      }
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day + i, 12, 0, 0, 0, 0);
      String ngay = DateFormat("dd/M/yyyy").format(today);
      // pref.setStringList(_listMeal[i].id.toString(), foodName);
      pref.setStringList(ngay, foodName);
      if(ngay == DateFormat("dd/M/yyyy").format(now)) {//Tính số calo cần tiên thụ 1 ngày lưu vào biến tổng.
        CurrentUser.totalCaloDate = _listMeal[i].caloDate;
      }
    }
    Navigator.of(_context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()),(Route<dynamic> route) => false);
  }).onError((error, stackTrace){
    Navigator.of(_context).pushReplacement(MaterialPageRoute(builder: (context) => BMIScreen()));
    print("LỖI: "+ error.toString());
  });
}