import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttonQuaterCircleBack(String _text){
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.background,
          Colors.purple,
        ],
      ),
        borderRadius: BorderRadius.only(topRight: Radius.circular(120)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),

            Text(_text, style: TextStyle(color: Colors.white, fontSize: 30,),),

            SizedBox(height: 10,),

            Icon(Icons.arrow_back_rounded,color: Colors.white,size: 50,),
          ],
        ),
      ),
    ),
  );
}