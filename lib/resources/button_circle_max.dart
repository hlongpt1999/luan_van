import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonCircleMax (BuildContext context, String _text,{ Color color1, Color color2, Color colorText}){
  return Container(
    width: MediaQuery.of(context).size.width - 60,
    height: 60.0,
    alignment: FractionalOffset.center,
    decoration: new BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color1 ?? Colors.deepOrange,
          color2 ?? Colors.orangeAccent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
    ),
    child: new Text(
      _text,
      style: GoogleFonts.quicksand(
        color: colorText ?? Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    ),
  );
}