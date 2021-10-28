import 'package:flutter/material.dart';
import 'package:luan_van/model/User.dart';

class Const{
  static final String LOGIN_PREF = "LoginPref";
  static int colorMainPaint = 0xffff9900;
  static int colorMiddlePaint = 0x12345678;
  static int colorLowPaint = 0x87654321;

}

class MyColor{
  static int colorBackground2 = 0xFF42A5F5;
  static Color colorBackgroundTab = Color(0xFF9E9E9E);
}

//Đồng bộ các size với nhau để có trường hợp thay đổi.
class MySize{
  static double heightNextBack = 70.0;
  static double radiusNextBack = 30.0;
  static double paddingHor = 24.0;
  static double heightAppBar = 90;
}

class MyList{
  List<String> listDate = [
    "Ngày 1",
    "Ngày 2",
    "Ngày 3",
    "Ngày 4",
    "Ngày 5",
    "Ngày 6",
    "Ngày 7"
  ];

  var listColorTitle = [
    Colors.brown,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.lightBlue,
    Colors.purple,
    Colors.pink
  ];

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class CurrentUser {
  static UserModel currentUser = UserModel();
}