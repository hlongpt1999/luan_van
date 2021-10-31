import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/model/FoodModel.dart';

class MockData{
  List<DateMealModel> listMeal = [date1, date2, date3, date4, date5, date6, date7];

  static DateMealModel date1 = new DateMealModel(id: 1, caloDate: 1245, foods: dateMeal1);
  static List<FoodModel> dateMeal1 =<FoodModel>[food1, food2,food3,food4];
  static FoodModel food1 = new FoodModel(name: "Thịt heo", calo100g: 100, quantity: 30);
  static FoodModel food2 = new FoodModel(name: "Rau xanh", calo100g: 50, quantity: 25);
  static FoodModel food3 = new FoodModel(name: "Cơm", calo100g: 100, quantity: 5);

  static DateMealModel date2 = new DateMealModel(id: 2, caloDate: 1245, foods: dateMeal2);
  static List<FoodModel> dateMeal2 =<FoodModel>[food6, food4,food5];
  static FoodModel food4 = new FoodModel(name: "Cải thìa", calo100g: 30, quantity: 2);
  static FoodModel food5 = new FoodModel(name: "Cám", calo100g: 90, quantity: 10);
  static FoodModel food6 = new FoodModel(name: "Thịt bò", calo100g: 220, quantity: 2);

  static DateMealModel date3 = new DateMealModel(id: 3, caloDate: 1245, foods: dateMeal3);
  static List<FoodModel> dateMeal3 =<FoodModel>[food1, food5,food7];
  static FoodModel food7 = new FoodModel(name: "Thịt cừu", calo100g: 230, quantity: 2);

  static DateMealModel date4 = new DateMealModel(id: 4, caloDate: 1245, foods: dateMeal4);
  static List<FoodModel> dateMeal4 =<FoodModel>[food1, food5, food7, food4, food2, food2, food3];

  static DateMealModel date7 = new DateMealModel(id: 7, caloDate: 1245, foods: dateMeal1);

  static DateMealModel date5 = new DateMealModel(id: 5, caloDate: 1245, foods: dateMeal2);

  static DateMealModel date6 = new DateMealModel(id: 6, caloDate: 1245, foods: dateMeal3);
}