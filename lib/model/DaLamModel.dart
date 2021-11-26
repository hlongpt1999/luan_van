import 'package:cloud_firestore/cloud_firestore.dart';

class DaLamModel{
  Timestamp time = Timestamp.now();
  double totalFoodCalo = 0.0;
  double totalDongTacCalo = 0.0;
  int caloFoodDate = 0;
  int caloDongTacDate = 0;

  DaLamModel({this.time, this.totalFoodCalo, this.totalDongTacCalo,
      this.caloFoodDate, this.caloDongTacDate});

  DaLamModel.fromJson(Map<String, dynamic> json){
    time = json["time"] ?? Timestamp.now();
    totalFoodCalo = json["totalFoodCalo"] ?? 0.0;
    totalDongTacCalo = json["totalDongTacCalo"] ?? 0.0;
    caloFoodDate = json["caloFoodDate"] ?? 0;
    caloDongTacDate = json["caloDongTacDate"] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      "totalFoodCalo" : totalFoodCalo ?? 0.0,
      "totalDongTacCalo" : totalDongTacCalo ?? 0.0,
      "caloFoodDate" : caloFoodDate ?? 0,
      "caloDongTacDate" :caloDongTacDate ?? 0,
      "time" : time ?? Timestamp.now(),
    };
  }
}