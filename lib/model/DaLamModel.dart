import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luan_van/components/Constants.dart';

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

class HistoryBMI{
  Timestamp time = Timestamp.now();
  double height = CurrentUser.currentUser.height;
  double weight = CurrentUser.currentUser.weight;
  double bmi = 1.0;
  int tuoi = 20;
  String sex = CurrentUser.currentUser.sex;
  double duongHuyet = 0.0;
  double huyetAp = 0.0;

  HistoryBMI({this.time, this.height, this.weight, this.bmi, this.tuoi, this.sex,
      this.duongHuyet, this.huyetAp});

  HistoryBMI.fromJson(Map<String, dynamic> json){
    time = json["time"] ?? Timestamp.now();
    height = json["height"] ?? 175;
    weight = json["weight"] ?? 50;
    bmi = json["bmi"] ?? 1.0;
    tuoi = json["tuoi"] ?? 0;
    sex = json["sex"] ?? "Nam";
    duongHuyet = json["duongHuyet"] ?? 0.0;
    huyetAp = json["huyetAp"] ?? 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      "time" : time ?? Timestamp.now(),
      "height" : height ?? 175,
      "weight" : weight ?? 50,
      "bmi" : bmi ?? 1.0,
      "tuoi" : tuoi ?? 20,
      "sex" : sex ?? "Nam",
      "duongHuyet" : duongHuyet ?? 0.0,
      "huyetAp" : huyetAp ?? 0.0,
    };
  }
}