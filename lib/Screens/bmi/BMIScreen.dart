import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/resources/button_quater_circle_back.dart';
import 'package:luan_van/resources/button_quater_circle_next.dart';
import 'package:luan_van/resources/styles.dart';

class BMIScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BMIScreenState();
}

class BMIScreenState extends State<BMIScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // Not move screen when show keyboard
      body: Container(
        decoration: new BoxDecoration(color: Colors.blue,),
        child: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(width: 20,),

                    new Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Enter your weight",
                            labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20),),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20),),
                            ),
                            prefixIcon: Icon(
                              Icons.line_weight_rounded,
                              color: Colors.white,),
                          ),
                          style: TextStyle(fontSize: 40),
                          keyboardType: TextInputType.number,
                        ),
                    ),

                    measureText("KG"),

                  ],
                ),

                SizedBox(height: 30,),

                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(width: 20,),

                    new Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter your height",
                          labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20),),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20),),
                          ),
                          prefixIcon: Icon(
                            Icons.height,
                            color: Colors.white,),
                        ),
                        style: TextStyle(fontSize: 40),
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    measureText("CM"),

                  ],
                ),
              ],
            ),
          ),

          buttonQuaterCircleNext("Next"),
          buttonQuaterCircleBack("Back"),
        ],
        ),
      ),
    );
  }
}

Widget measureText(String _text){
  return Container(
    alignment: Alignment.center,
    width: 140,
    padding: const EdgeInsets.all(20),
    child: Text(_text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
    ),
  );
}

