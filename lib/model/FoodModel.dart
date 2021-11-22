import 'package:flutter/src/material/dropdown.dart';

class FoodModel{
  String idFood = "";
  String name = "";
  String type = ""; //Loại : Thịt cá/ Trứng sữa / Trái cây/ Rau củ/ Tinh bột
  List<String> vitamin = ["A", "B", "C"];
  double calo100g = 0;
  int priority = 0; //1 = calo ít, 2 =... , 5=calo cực cao
  String foodImage = "";
  int quantity = 1;

  FoodModel({this.idFood, this.name, this.type, this.vitamin, this.calo100g,
      this.priority, this.foodImage, this.quantity});

  FoodModel.fromJson(Map<String, dynamic> json){
    idFood = json["idFood"] ?? "";
    name = json["name"] ?? "";
    type = json["type"] ?? "";
    calo100g = double.parse(json["calo100g"].toString()) ?? 0.0;
    if(json["vitamin"]!=[] && json["vitamin"] != null){
      vitamin = List.from(json["vitamin"]);
    } else vitamin = [];
    priority = json["priority"] ?? 0;
    foodImage = json["foodImage"] ?? "";
    quantity = json["quantity"] ?? 0;
  }

  Map<String, dynamic> toMap(){
    return {
      "idFood" : idFood ?? name,
      "name" : name,
      "type" : type,
      "vitamin" : vitamin,
      "calo100g" : calo100g,
      "priority" : priority,
      "foodImage" : foodImage,
      "quantity" : quantity,
    };
  }
}