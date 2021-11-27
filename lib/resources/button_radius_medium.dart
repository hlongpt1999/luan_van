import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonRadiusMedium(String _title, Color _color){
  return Container(
    width: 150,
    height: 50,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          _color,
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(1),
          spreadRadius: 7,
          blurRadius: 10,
          offset: Offset(1, 3), // changes position of shadow
        ),
      ],
    ),
    child: Center(
      child: Text(
        _title,
        style: GoogleFonts.quicksand(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}