import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget boxBMISelect(String _textChoice, DecorationImage _backgroundColor, IconData _icon){
  return Container(
    // margin: EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
    height: 120,
    width: 300,
    decoration: BoxDecoration(
      image: _backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(1),
          spreadRadius: 7,
          blurRadius: 10,
          offset: Offset(1, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Icon(
            _icon,
            size: 50,
          ),
        ),

        Flexible(
          child: Text(
            _textChoice,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),

      ],
    ),
  );
}