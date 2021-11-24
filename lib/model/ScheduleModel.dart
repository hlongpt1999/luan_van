import 'package:luan_van/model/DateMealModel.dart';

import 'DateLuyenTapModel.dart';

class ScheduleModel{
  int totalCalo;
  DateMealModel date1;
  DateMealModel date2;
  DateMealModel date3;
  DateMealModel date4;
  DateMealModel date5;
  DateMealModel date6;
  DateMealModel date7;
  String name;

  ScheduleModel({this.totalCalo, this.date1, this.date2, this.date3, this.date4,
    this.date5, this.date6, this.date7, this.name});

  ScheduleModel.fromJson(Map<String, dynamic> json){
    totalCalo = json["totalCalo"];
    date1 = json["date1"];
    date2 = json["date2"];
    date3 = json["date3"];
    date4 = json["date4"];
    date5 = json["date5"];
    date6 = json["date6"];
    date7 = json["date7"];
    name = json["name"] ?? "Mọi đối tượng";
  }

  Map<String, dynamic> toMap(){
    return {
      "totalCalo" : totalCalo,
      "date1" : date1,
      "date2" : date2,
      "date3" : date3,
      "date4" : date4,
      "date5" : date5,
      "date6" : date6,
      "date7" : date7,
      "name" : name,
    };
  }

}

class ScheduleLuyenTapModel{
  int totalCalo;
  DateLuyenTapModel date1;
  DateLuyenTapModel date2;
  DateLuyenTapModel date3;
  DateLuyenTapModel date4;
  DateLuyenTapModel date5;
  DateLuyenTapModel date6;
  DateLuyenTapModel date7;
  String name;

  ScheduleLuyenTapModel({this.totalCalo, this.date1, this.date2, this.date3, this.date4,
    this.date5, this.date6, this.date7, this.name});

  ScheduleLuyenTapModel.fromJson(Map<String, dynamic> json){
    totalCalo = json["totalCalo"];
    date1 = json["date1"];
    date2 = json["date2"];
    date3 = json["date3"];
    date4 = json["date4"];
    date5 = json["date5"];
    date6 = json["date6"];
    date7 = json["date7"];
    name = json["name"] ?? "Mọi đối tượng";
  }

  Map<String, dynamic> toMap(){
    return {
      "totalCalo" : totalCalo,
      "date1" : date1,
      "date2" : date2,
      "date3" : date3,
      "date4" : date4,
      "date5" : date5,
      "date6" : date6,
      "date7" : date7,
      "name" : name,
    };
  }

}
