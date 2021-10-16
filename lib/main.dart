import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/signup/SignUpScreen.dart';
import 'screens/login/LoginScreen.dart';

void main (){
  //Câu lệnh cố định màn hình không cho nó xoay ngang.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_){
    runApp(
      new MaterialApp(
        home: SignUpScreen(),
      )
    );
  });
}
