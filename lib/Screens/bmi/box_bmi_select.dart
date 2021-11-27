import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        SizedBox(width: 5,),
        Container(
          padding: const EdgeInsets.all(5.0),
          child: new Icon(
            _icon,
            size: 50,
          ),
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black
                      .withOpacity(0.6),
                  offset: const Offset(1.1, 4.0),
                  blurRadius: 8.0),
            ],
            borderRadius: BorderRadius.all(Radius.circular(180),),
            color: Colors.white,
          ),
        ),

        SizedBox(width: 5,),
        Flexible(
          child: Text(
            _textChoice,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0,0),
                  blurRadius: 15.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(0,0),
                  blurRadius: 20.0,
                  color: Color.fromARGB(125, 255, 0, 0),
                ),
              ],
            ),
          ),
        ),

      ],
    ),
  );
}