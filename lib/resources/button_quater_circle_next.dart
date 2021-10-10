import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttonQuaterCircleNext(String _text){
  return Align(
    alignment: Alignment.bottomRight,
    child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.deepOrange,
              Colors.purple,
            ],
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(120)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10,),

              Text(_text, style: TextStyle(color: Colors.white, fontSize: 30,),),

              SizedBox(height: 10,),

              Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 50,),
            ],
          ),
        ),
    ),
  );
}