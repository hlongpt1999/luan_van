import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/resources/button_outline.dart';
import 'package:luan_van/resources/button_radius_big.dart';

class SignUpScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Not move screen when show keyboard
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonOutLine(),

              ButtonRadiusBig(),
            ],
          ),
        ),
      ),
    );
  }
}