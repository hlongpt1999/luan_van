import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ButtonOutLine(){
  return OutlinedButton.icon(
    icon: Icon(Icons.star_outline),
    label: Text("OutlinedButton"),
    style: ElevatedButton.styleFrom(
      side: BorderSide(width: 2.0, color: Colors.blue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    ),
  );
}