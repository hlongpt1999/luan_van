import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luan_van/model/MovementModel.dart';

class DateLuyenTapModel{
  int id = 0;
  int caloDate = 0;
  List<MovementModel> dongTac = [];
  Timestamp time = Timestamp.now();

  DateLuyenTapModel({this.id, this.caloDate, this.dongTac, this.time});

  DateLuyenTapModel.fromJson(Map<String, dynamic> json){
    id = json["id"];
    caloDate = json["caloDate"];
    var messages = List<Map<String, dynamic>>.from(json["dongTac"] as List<dynamic>);
    dongTac = messages.map((m) => MovementModel.fromJson(m)).toList();
    time = json["time"] ?? Timestamp.now();
    // foods = FoodModel.fromJson(json["foods"]).toList();
  }

  Map<String, dynamic> toMap() {
    List dongTacMap = [];
    for(int i=0;i<dongTac.length;i++){
      dongTacMap.add(dongTac[i].toMap());
    }

    return {
      "id" : id,
      "caloDate" : caloDate,
      "dongTac" : FieldValue.arrayUnion(dongTacMap),
      "time" : time,
    };
  }
}