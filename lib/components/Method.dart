import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/ChatModel.dart';
import 'package:luan_van/model/DateLuyenTapModel.dart';
import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/bmi/EvaluateBMIScreen.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/schedule/MockData.dart';
import 'package:luan_van/screens/setting/DatGioScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> getSchedule(String idUser, BuildContext _context) async{
  MockData.listMeal2 = [];
  MockData.listLuyenTap = [];

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
              if(i==0){
                CurrentUser.lichHomNay = true;
              }
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

    if(MockData.listMeal2.length>1) // Vậy là ngày mai vẫn có lịch.
      CurrentUser.lichNgayMai = true;
    else CurrentUser.lichNgayMai = false;

    for (var i = 0; i<MockData.listMeal2.length; i++){
      foodName.clear();
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
              avatar,
              _listMeal[i].foods[j].type, //Loại để show màu
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
    getLuyenTapShow(idUser, _context);
  }).onError((error, stackTrace){
    Navigator.of(_context).pushReplacement(MaterialPageRoute(builder: (context) => BMIScreen()));
    print("LỖI: "+ error.toString());
  });


}

Future<void> getLuyenTapShow(String idUser, BuildContext _context) async{
  await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(idUser).collection("scheduleLuyenTap").get().then(
          (value){
        value.docs.forEach((element) async {
          var data = element.data() as Map<String, dynamic>;
          final now = DateTime.now();
          DateLuyenTapModel dateLuyenTapModel = new DateLuyenTapModel.fromJson(data);
          for(int i=0; i<7;i++){
            if(dateLuyenTapModel.time.toDate().day== now.day + i &&
                dateLuyenTapModel.time.toDate().month == now.month &&
                dateLuyenTapModel.time.toDate().year == now.year){
              MockData.listLuyenTap.add(dateLuyenTapModel);
            }
          }
        });
      }
  ).whenComplete(() async {
    for (int j=0 ; j<MockData.listLuyenTap.length-1;j++)
      for (int k=j+1; k <MockData.listLuyenTap.length;k++){
        if(MockData.listLuyenTap[j].time.millisecondsSinceEpoch > MockData.listLuyenTap[k].time.millisecondsSinceEpoch ){
          DateLuyenTapModel temp = MockData.listLuyenTap[j];
          MockData.listLuyenTap[j] = MockData.listLuyenTap[k];
          MockData.listLuyenTap[k] = temp;
        }
      }
    List<DateLuyenTapModel> _listLuyenTap = MockData.listLuyenTap;
    //TODO: ID_NUMER 1
    List<String> dongTacName=[];
    SharedPreferences pref = await SharedPreferences.getInstance();
    for (var i = 0; i<MockData.listLuyenTap.length; i++){
      dongTacName.clear();
      for (var j=0; j<_listLuyenTap[i].dongTac.length ; j++){
        dongTacName.add(_listLuyenTap[i].dongTac[j].name);
        var ref = firebase_storage.FirebaseStorage.instance
            .ref(_listLuyenTap[i].dongTac[j].imageDetail);
        String avatar = await ref.getDownloadURL();
        String link =  _listLuyenTap[i].dongTac[j].link ?? "";
        //Lưu dữ liệu món ăn (Theo thứ tự lần lượt là: 0- Calo, 1- quanlity , 2-LinkdownfoodImage, 3 - link youtube
        pref.setStringList(_listLuyenTap[i].dongTac[j].name,
            [
              _listLuyenTap[i].dongTac[j].caloLost100g.toString(),
              _listLuyenTap[i].dongTac[j].quantity.toString(),
              avatar,
              link,
            ]);
      }
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day + i, 12, 0, 0, 0, 0);
      String ngay = DateFormat("dd/M/yyyy").format(today);
      pref.setStringList(ngay+Const.PREF_LUYENTAP, dongTacName);
      if(ngay == DateFormat("dd/M/yyyy").format(now)) {//Tính số calo cần tiên thụ 1 ngày lưu vào biến tổng.
        CurrentUser.totalCaloDateLost = _listLuyenTap[i].caloDate;
      }
    }
    List<String> list = await pref.getStringList(Const.KEY_DAT_GIO) ?? ["null"];
    if(list[0] == "null")
      luuLich();
    else{
      CurrentUser.lichNhacNho = list[0] == "true" ? true : false;
      CurrentUser.nhacNhoGIO = int.parse(list[1]);
      CurrentUser.nhacNhoPHUT= int.parse(list[2]);
      CurrentUser.lichDaLam = list[3] == "true" ? true : false;
      CurrentUser.daLamGIO = int.parse(list[4]);
      CurrentUser.daLamPHUT= int.parse(list[5]);
    }
    if(CurrentUser.lichHomNay)
      Navigator.of(_context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()),(Route<dynamic> route) => false);
    else
      Navigator.of(_context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => EvaluateBMIScreen()),(Route<dynamic> route) => false);
  }).onError((error, stackTrace){
    Navigator.of(_context).pushReplacement(MaterialPageRoute(builder: (context) => BMIScreen()));
    print("LỖI: "+ error.toString());
  });
}