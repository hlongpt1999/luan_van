import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ButtonCircleMax (BuildContext context, String _text){
  return Container(
    width: 320.0,
    height: 60.0,
    alignment: FractionalOffset.center,
    decoration: new BoxDecoration(
      color: Colors.background,
      borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
    ),
    child: new Text(
      _text,
      style: new TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    ),
  );
}