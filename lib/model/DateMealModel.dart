import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luan_van/model/FoodModel.dart';

class DateMealModel {
  int id = 0;
  int caloDate = 0;
  List<FoodModel> foods = [];
  Timestamp time = Timestamp.now();

  DateMealModel({this.id, this.caloDate, this.foods});

  DateMealModel.fromJson(Map<String, dynamic> json){
    id = json["id"];
    caloDate = json["caloDate"];
    var messages = List<Map<String, dynamic>>.from(json["foods"] as List<dynamic>);
    foods = messages.map((m) => FoodModel.fromJson(m)).toList();
    time = json["time"] ?? Timestamp.now();
  }

  Map<String, dynamic> toMap() {
    List foodMap = [];
    for(int i=0;i<foods.length;i++){
      foodMap.add(foods[i].toMap());
    }

    return {
      "id" : id,
      "caloDate" : caloDate,
      "foods" : FieldValue.arrayUnion(foodMap),
      "time" : time,
    };
  }
}