import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/resources/button_quater_circle_back.dart';
import 'package:luan_van/resources/button_quater_circle_next.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/bmi/EvaluateBMIScreen.dart';

import '../../main.dart';

class BMIScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BMIScreenState();
}

class BMIScreenState extends State<BMIScreen>{
  TextEditingController _weightController = new TextEditingController();
  TextEditingController _heightController = new TextEditingController();
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
                          controller: _weightController,
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
                          controller: _heightController,
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

            GestureDetector(
                onTap: onNextClick,
                child: buttonQuaterCircleNext("Next")
            ),

            GestureDetector(
                onTap: onBackClick,
                child: buttonQuaterCircleBack("Back")),
          ],
        ),
      ),
    );
  }

  void onNextClick() {
    setState(() {
      if (checkInputType()){
        double BMI = getBMI(double.parse(_weightController.text),double.parse(_heightController.text));
        if(isValidData()) Navigator.of(context).push(MaterialPageRoute(builder: (context) => EvaluateBMIScreen()));
        else showDialog(context: context,
            child: new AlertDialog(
              title: Text("BMI"),
              content: Text(isValidData()? BMI.toString() : "Abnormal height/height index "),
            ));
      }else
        showDialog(context: context,
          child: new AlertDialog(
            title: Text("Input wrong"),
            content: Text( isInputData() ? "Please enter the number." : "Please enter full"),
          ));
    });
  }

  void onBackClick() => Navigator.pop(context);

  bool isValidData(){
    //TODO: Xem lại giá trị để chiều cao và cân nặng hợp lệ
    var height = double.parse(_heightController.text);
    var weight = double.parse(_weightController.text);
    if(height>29 && height<250 && weight>19 && weight<250) {return true;}
    else {return false;}
  }

  bool isInputData() => (_weightController.text.isNotEmpty && _heightController.text.isNotEmpty);

  bool checkInputType(){
      try{
        var weight = double.parse(_weightController.text);
        var height = double.parse(_heightController.text);
      }catch(e){
        return false;
      }
      return true;
  }

  double getBMI(var weight, var height_CM){
    var height_M = height_CM/100;
    return weight/(height_M * height_M);
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

