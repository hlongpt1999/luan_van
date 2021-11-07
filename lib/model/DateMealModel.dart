import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luan_van/model/FoodModel.dart';

class DateMealModel {
  double id = 0;
  int caloDate = 0;
  List<FoodModel> foods = [];

  DateMealModel({this.id, this.caloDate, this.foods});

  Map<String, dynamic> toMap() {
    List foodMap = [];
    for(int i=0;i<foods.length;i++){
      foodMap.add(foods[i].toMap());
    }

    return {
      "id" : id,
      "caloDate" : caloDate,
      "foods" : FieldValue.arrayUnion(foodMap),
    };
  }
}