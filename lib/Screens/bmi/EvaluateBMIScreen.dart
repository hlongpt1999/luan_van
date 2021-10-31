import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/resources/background_painter_circle.dart';
import 'package:luan_van/resources/button_outline.dart';
import 'package:luan_van/screens/bmi/box_bmi_select.dart';
import 'package:luan_van/screens/schedule/CreateScheduleScreen.dart';

class EvaluateBMIScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EvaluateBMIScreenState();
}

class EvaluateBMIScreenState extends State<EvaluateBMIScreen> {
  double _BMI = 20;
  //TODO: Truyền vào giá trị giới tính.
  var _gender = "male";
  bool _isShowChoice = true;
  var _listIcon  = new List<IconData>(3);
  Color _textColor;

  @override
  void initState() {
    if (evaluateBmiLevel(_BMI)==1 || evaluateBmiLevel(_BMI)==5)
      _isShowChoice = false;
    else _isShowChoice = true;

    evaluateBmiText(_BMI);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(),
        child: Center(
          child: Stack(
            children: [
              backgroundPainterCircle(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Chỉ số BMI của bạn là: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      children: [
                        TextSpan (
                          text: CurrentUser.currentUser.bmi.toString(),
                          style: TextStyle(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Flexible(
                      child: Text(
                        evaluateBmiText(_BMI),
                        style: TextStyle(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                  boxBMISelect(showTitleChoice(1), Colors.blue, _listIcon[0]),

                  SizedBox(height: 30,),
                  boxBMISelect(showTitleChoice(2), Colors.green, _listIcon[1]),

                  if(_isShowChoice) SizedBox(height: 30,),
                  if(_isShowChoice) boxBMISelect(showTitleChoice(3), Colors.yellow, _listIcon[2]),

                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: refresh,
                    child: ButtonOutLine(),
                  ),

                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: refreshadd,
                    child: ButtonOutLine(),
                  ),

                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: ((){
                      setState(() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateScheduleScreen()));
                      });
                    }),
                    child: ButtonOutLine(),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  int evaluateBmiLevel(double BMI){
    if(_gender == "male"){
      if(_BMI < 15) return 1;
      else if(15 <= _BMI && _BMI < 20) return 2;
      else if(20 <= _BMI && _BMI < 25) return 3;
      else if(25 <= _BMI && _BMI < 30) return 4;
      else if(30 <= _BMI) return 5;
    }else{
      if(_BMI < 14) return 1;
      else if(14 <= _BMI && _BMI < 18.5) return 2;
      else if(18.5 <= _BMI && _BMI < 25) return 3;
      else if(25 <= _BMI && _BMI < 30) return 4;
      else if(30 <= _BMI) return 5;
    }
  }

  String evaluateBmiText(double BMI){
    String _evaluateText = "";
    switch(evaluateBmiLevel(BMI)){
      case 1:{
        _evaluateText = "Thiếu cân nghiêm trọng!\nBạn khá là thiếu cân nặng để có cơ thể khỏe mạnh";
        setState(() {
          _textColor = Colors.deepOrange;
        });
      }break;

      case 2:{
        _evaluateText = "Bạn đang thiếu cân!\nBạn cần cải thiện thêm cân nặng để có cơ thể khỏe mạnh";
        setState(() {
          _textColor = Colors.yellow;
        });
      }break;
    //Trong chỉ số cơ thể ổn chia nhiều loại.
      case 3:{
        if (BMI>24)    _evaluateText = "Chỉ số cơ thể của bạn khá ổn.\nNhưng sắp đạt mức cân nặng cao";
        else if (BMI<21.5)   _evaluateText = "Chỉ số cơ thể của bạn khá ổn.\nBạn nên tăng cân nhẹ để cho cơ thể khỏe mạnh hơn.";
        else       _evaluateText = "♥ Cân đối ♥\nCần giữ vóc dáng để có cơ thể khỏe mạnh";
        setState(() {
          _textColor = Colors.green;
        });
      }break;

      case 4:{
        _evaluateText = "Bạn đang thừa cân.\nBạn cần giảm bớt cân nặng để có cơ thể khỏe mạnh hơn.";
        setState(() {
          _textColor = Colors.yellow;
        });
      }break;

      case 5:{
        _evaluateText = "Bạn đang bị béo phì!\nBạn khá là thừa cân nặng để có cơ thể khỏe mạnh";
        setState(() {
          _textColor = Colors.deepOrange;
        });
      }break;
    }
    return _evaluateText;
  }

  String showTitleChoice(int position){
    String _title = "";
    switch(position){
      case 1: {
        switch(evaluateBmiLevel(_BMI)){
          case 1:{
            _title = "Tăng cân từ từ";
            setState(() {
              _listIcon[0] = Icons.upgrade_sharp;
            });
          }break;

          case 2:{
            _title = "Giữ vóc dáng";
            setState(() {
              _listIcon[0] = Icons.all_inclusive_sharp;
            });
          }break;

          case 3:{
            _title = "Giảm cân";
            setState(() {
              _listIcon[0] = Icons.download_sharp;
            });
          }break;

          case 4:{
            _title = "Giảm cân nhanh chóng";
            setState(() {
              _listIcon[0] = Icons.upload_sharp;
            });
          }break;

          case 5:{
            _title = "Giảm cân nhanh chóng";
            setState(() {
              _listIcon[0] = Icons.upload_sharp;
            });
          }break;
        }
      }break;

      case 2:{
        switch(evaluateBmiLevel(_BMI)){
          case 1:{
            _title = "Tăng cân nhanh chóng";
            setState(() {
              _listIcon[1] = Icons.warning_amber_sharp;
            });
          }break;

          case 2:{
            _title = "Tăng cân hợp lý";
            setState(() {
              _listIcon[1] = Icons.upgrade_sharp;
            });
          }break;

          case 3:{
            _title = "Giữ vóc dáng";
            setState(() {
              _listIcon[1] = Icons.all_inclusive_sharp;
            });
          }break;

          case 4:{
            _title = "Giảm cân hợp lý";
            setState(() {
              _listIcon[1] = Icons.download_sharp;
            });
          }break;

          case 5:{
            _title = "Giảm cân từ từ";
            setState(() {
              _listIcon[1] = Icons.download_sharp;
            });
          }break;
        }
      }break;

      case 3:{
        switch(evaluateBmiLevel(_BMI)){
          case 1:{
            _title = "";
            setState(() {
              _listIcon[2] = null;
            });
          }break;

          case 2:{
            _title = "Tăng cân nhanh chóng";
            setState(() {
              _listIcon[2] = Icons.warning_amber_sharp;
            });
          }break;

          case 3:{
            _title = "Tăng cân";
            setState(() {
              _listIcon[2] = Icons.upgrade_sharp;
            });
          }break;

          case 4:{
            _title = "Giữ vóc dáng";
            setState(() {
              _listIcon[2] = Icons.warning_amber_sharp;
            });
          }break;

          case 5:{
            _title = "";
            setState(() {
              _listIcon[1] = null;
            });
          }break;
        }
      }break;
    }
    return _title;
  }

  void refresh(){
    setState(() {
      _BMI --;
      initState();
    });
  }

  void refreshadd(){
    setState(() {
      _BMI ++;
      initState();
    });
  }
}