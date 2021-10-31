import 'package:luan_van/model/FoodModel.dart';

class DateMealModel {
  int id = 0;
  int caloDate = 0;
  List<FoodModel> foods = [];

  DateMealModel({this.id, this.caloDate, this.foods});
}