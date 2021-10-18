import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttonRadiusBig(){
  return Container(
    width: 300,
    height: 100,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.deepOrange,
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(5, 5),
          blurRadius: 10,
        )
      ],
    ),
    child: Center(
      child: Text(
        'Press',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}