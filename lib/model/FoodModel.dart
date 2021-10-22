class FoodModel{
  String idFood = "";
  String name = "";
  String type = ""; //Loại ngũ cốc, thịt cá, trái cây, rau xanh,, sữa
  List<String> vitamin = ["A", "B", "C"];
  double calo100g = 0;
  int priority = 0; //1 = calo ít, 2 =... , 5=calo cực cao
  String foodImage = "";

  FoodModel({this.idFood, this.name, this.type, this.vitamin, this.calo100g,
      this.priority, this.foodImage});

  Map<String, dynamic> toMap(){
    return {
      "idFood" : idFood,
      "name" : name,
      "type" : type,
      "vitamin" : vitamin,
      "calo100g" : calo100g,
      "priority" : priority,
      "foodImage" : foodImage,
    };
  }


}