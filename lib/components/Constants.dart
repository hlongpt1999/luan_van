import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/MovementModel.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Const{
  static final String VERSION = "Beta version 1.0.5";
  static final String VERSION_DATE = "24/11/2021";
  static final String LOGIN_PREF = "LoginPref";

  static String KEY_FROM = "";
  static int colorMainPaint = 0xffff9900;
  static int colorMiddlePaint = 0x12345678;
  static int colorLowPaint = 0x87654321;

  static final String CSDL_FOODS = "Foods";
  static final String CSDL_TEST = "test";
  static final String CSDL_LICH = "schedule";
  static final String CSDL_USERS = "users";
  static final String CSDL_DONGTAC = "dongtac";
  static final String CSDL_SCHEDULE_LUYENTAP = "scheduleLuyenTap";

  static final String COLLECTION_DALAM = "historyDaLam";

  static final String FROM_BMI = "FROM_BMI";
  static final String FROM_CREATE_SCHEDULE = "FROM_CREATE_SCHEDULE";
  static final String FROM_CREATE_SCHEDULE_LUYENTAP = "FROM_CREATE_SCHEDULE_LUYENTAP";
  static final String FROM_SCHEDULE = "FROM_SCHEDULE";

  static final String PREF_LUYENTAP = "luyenTap";
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
  static List<FoodModel> listFood = [];
  static List<String> listFoodString = [];

  static List<MovementModel> listDongTac = [];
  static List<String> listDongTacString = [];

  static int totalCaloDate = 0;
  static int totalCaloDateLost = 0;
  static UserModel userConnect = UserModel();
  static bool lichNgayMai = true;
}

Future<void> onLogOut(BuildContext context) async {
  CurrentUser.currentUser = new UserModel();
  CurrentUser.listFood = [];
  CurrentUser.listFoodString = [];
  CurrentUser.totalCaloDate = 0;
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(Const.LOGIN_PREF);
  for(String key in pref.getKeys()) {
    pref.remove(key);
  }
  pref.clear();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  await FirebaseAuth.instance.signOut();
}