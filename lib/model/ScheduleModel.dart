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
  String gioiTinh;
  int minTuoi;
  int maxTuoi;

  ScheduleModel({this.totalCalo, this.date1, this.date2, this.date3, this.date4,
    this.date5, this.date6, this.date7, this.name, this.gioiTinh, this.minTuoi, this.maxTuoi});

  DateMealModel giaTriRong = DateMealModel();

  ScheduleModel.fromJson(Map<String, dynamic> json){
    totalCalo = json["totalCalo"];
    date1 = json["date1"] ?? giaTriRong;
    date2 = json["date2"] ?? giaTriRong;
    date3 = json["date3"] ?? giaTriRong;
    date4 = json["date4"] ?? giaTriRong;
    date5 = json["date5"] ?? giaTriRong;
    date6 = json["date6"] ?? giaTriRong;
    date7 = json["date7"] ?? giaTriRong;
    name = json["name"] ?? "Mọi đối tượng";
    gioiTinh = json["gioiTinh"] ?? "Nam và nữ";
    maxTuoi = json["maxTuoi"] ?? 70;
    minTuoi = json["minTuoi"] ?? 10;
  }

  Map<String, dynamic> toMap(){
    return {
      "totalCalo" : totalCalo,
      "date1" : date1 ?? giaTriRong,
      "date2" : date2 ?? giaTriRong,
      "date3" : date3 ?? giaTriRong,
      "date4" : date4 ?? giaTriRong,
      "date5" : date5 ?? giaTriRong,
      "date6" : date6 ?? giaTriRong,
      "date7" : date7 ?? giaTriRong,
      "name" : name ?? "Mọi đối tượng",
      "gioiTinh": gioiTinh ?? "Nam và nữ",
      "maxTuoi" : maxTuoi ?? 70,
      "minTuoi" : minTuoi ?? 10,
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
  String gioiTinh;
  int minTuoi;
  int maxTuoi;

  ScheduleLuyenTapModel({this.totalCalo, this.date1, this.date2, this.date3, this.date4,
    this.date5, this.date6, this.date7, this.name, this.gioiTinh, this.minTuoi, this.maxTuoi});

  DateLuyenTapModel giaTriRong = DateLuyenTapModel();

  ScheduleLuyenTapModel.fromJson(Map<String, dynamic> json){
    totalCalo = json["totalCalo"] ?? 2000;
    date1 = json["date1"] ?? giaTriRong;
    date2 = json["date2"] ?? giaTriRong;
    date3 = json["date3"] ?? giaTriRong;
    date4 = json["date4"] ?? giaTriRong;
    date5 = json["date5"] ?? giaTriRong;
    date6 = json["date6"] ?? giaTriRong;
    date7 = json["date7"] ?? giaTriRong;
    name = json["name"] ?? "Mọi đối tượng";
    gioiTinh = json["gioiTinh"] ?? "Nam và nữ";
    maxTuoi = json["maxTuoi"] ?? 70;
    minTuoi = json["minTuoi"] ?? 10;
  }

  Map<String, dynamic> toMap(){
    return {
      "totalCalo" : totalCalo ?? 2000,
      "date1" : date1 ?? giaTriRong,
      "date2" : date2 ?? giaTriRong,
      "date3" : date3 ?? giaTriRong,
      "date4" : date4 ?? giaTriRong,
      "date5" : date5 ?? giaTriRong,
      "date6" : date6 ?? giaTriRong,
      "date7" : date7 ?? giaTriRong,
      "name" : name ?? "Mọi đối tượng",
      "gioiTinh": gioiTinh ?? "Nam và nữ",
      "maxTuoi" : maxTuoi ?? 70,
      "minTuoi" : minTuoi ?? 10,
    };
  }
}
