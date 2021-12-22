import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/resources/background_painter_circle.dart';
import 'package:luan_van/resources/button_outline.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/bmi/SearchScheduleScreen.dart';
import 'package:luan_van/screens/bmi/box_bmi_select.dart';
import 'package:luan_van/screens/login/Login.dart';
import 'package:luan_van/screens/schedule/CreateScheduleScreen.dart';
import 'package:luan_van/screens/schedule/MockData.dart';

class EvaluateBMIScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EvaluateBMIScreenState();
}

class EvaluateBMIScreenState extends State<EvaluateBMIScreen> {
  double _BMI = CurrentUser.currentUser.bmi;
  var _gender = CurrentUser.currentUser.sex;
  bool _isShowChoice = true;
  var _listIcon  = new List<IconData>(3);
  Color _textColor;
  List goiCalo = [0,0,0];
  List goiCaloDC = [0,0,0];

  @override
  void initState() {
    if (evaluateBmiLevel(_BMI)==1 || evaluateBmiLevel(_BMI)==5)
      _isShowChoice = false;
    else _isShowChoice = true;

    MockData.listMeal2.clear();
    MockData.listLuyenTap.clear();
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
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      children: [
                        TextSpan (
                          text: _BMI.toStringAsFixed(2).toString(),
                          style: GoogleFonts.quicksand(
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
                        style: GoogleFonts.quicksand(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScheduleScreen()));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text(
                            "Tìm lịch theo tên",
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      // MockData.listMeal2.clear();
                      // MockData.listLuyenTap.clear();
                      Const.KEY_FROM = Const.FROM_BMI;
                      CurrentUser.goiCalo=goiCalo[0];
                      CurrentUser.goiCaloDC=goiCaloDC[0];
                      CurrentUser.tenGoi1 = Const.MOI_DOI_TUONG;
                      CurrentUser.tenGoi2 = Const.MOI_DOI_TUONG;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: boxBMISelect(showTitleChoice(1), foodBackground, _listIcon[0])
                  ),

                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: (){
                      // MockData.listMeal2.clear();
                      // MockData.listLuyenTap.clear();
                      Const.KEY_FROM = Const.FROM_BMI;
                      CurrentUser.goiCalo=goiCalo[1];
                      CurrentUser.goiCaloDC=goiCaloDC[1];
                      CurrentUser.tenGoi1 = Const.MOI_DOI_TUONG;
                      CurrentUser.tenGoi2 = Const.MOI_DOI_TUONG;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: boxBMISelect(showTitleChoice(2), balanceBackground, _listIcon[1]),
                  ),

                  if(_isShowChoice) SizedBox(height: 30,),
                  if(_isShowChoice) GestureDetector(
                      onTap: (){
                        // MockData.listMeal2.clear();
                        // MockData.listLuyenTap.clear();
                        Const.KEY_FROM = Const.FROM_BMI;
                        CurrentUser.goiCalo=goiCalo[2];
                        CurrentUser.goiCaloDC=goiCaloDC[2];
                        CurrentUser.tenGoi1 = Const.MOI_DOI_TUONG;
                        CurrentUser.tenGoi2 = Const.MOI_DOI_TUONG;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreateScheduleScreen()));
                      },
                      child: boxBMISelect(showTitleChoice(3), gymBackground, _listIcon[2]),),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  int evaluateBmiLevel(double BMI){
    if(_gender == "Nam"){
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

  // Nam 2400
  // Nu 2000

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
        else       _evaluateText = "Vóc dáng cân đối\nCần giữ vóc dáng để có cơ thể khỏe mạnh";
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
    setState(() {
      CurrentUser.currentUser.bmiText = _evaluateText;
    });
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
              if (_gender == "Nam"){
                goiCalo[0]=2500;
                goiCaloDC[0]=1000;
              }else {
                goiCalo[0]=2300;
                goiCaloDC[0]=800;
              }
            });
          }break;

          case 2:{
            _title = "Giữ vóc dáng";
            setState(() {
              _listIcon[0] = Icons.all_inclusive_sharp;
              if (_gender == "Nam"){
                goiCalo[0]=2500;
                goiCaloDC[0]=1300;
              }else {
                goiCalo[0]=2000;
                goiCaloDC[0]=1000;
              }
            });
          }break;

          case 3:{
            _title = "Giảm cân";
            setState(() {
              _listIcon[0] = Icons.download_sharp;
              if (_gender == "Nam"){
                goiCalo[0]=2300;
                goiCaloDC[0]=1300;
              }else {
                goiCalo[0]=1800;
                goiCaloDC[0]=800;
              }
            });
          }break;

          case 4:{
            _title = "Giảm cân nhanh chóng";
            setState(() {
              _listIcon[0] = Icons.upload_sharp;
              if (_gender == "Nam"){
                goiCalo[0]=2000;
                goiCaloDC[0]=1300;
              }else {
                goiCalo[0]=1500;
                goiCaloDC[0]=800;
              }
            });
          }break;

          case 5:{
            _title = "Giảm cân nhanh chóng";
            setState(() {
              _listIcon[0] = Icons.upload_sharp;
              if (_gender == "Nam"){
                goiCalo[0]=2000;
                goiCaloDC[0]=1300;
              }else {
                goiCalo[0]=1500;
                goiCaloDC[0]=800;
              }
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
              if (_gender == "Nam"){
                goiCalo[1]=2800;
                goiCaloDC[1]=800;
              }else {
                goiCalo[1]=2500;
                goiCaloDC[1]=800;
              }
            });
          }break;

          case 2:{
            _title = "Tăng cân hợp lý";
            setState(() {
              _listIcon[1] = Icons.upgrade_sharp;
              if (_gender == "Nam"){
                goiCalo[1]=2500;
                goiCaloDC[1]=1000;
              }else {
                goiCalo[1]=2300;
                goiCaloDC[1]=800;
              }
            });
          }break;

          case 3:{
            _title = "Giữ vóc dáng";
            setState(() {
              _listIcon[1] = Icons.all_inclusive_sharp;
              if (_gender == "Nam"){
                goiCalo[1]=2500;
                goiCaloDC[1]=1300;
              }else {
                goiCalo[1]=2000;
                goiCaloDC[1]=800;
              }
            });
          }break;

          case 4:{
            _title = "Giảm cân hợp lý";
            setState(() {
              _listIcon[1] = Icons.download_sharp;
              if (_gender == "Nam"){
                goiCalo[1]=2300;
                goiCaloDC[1]=1300;
              }else {
                goiCalo[1]=1800;
                goiCaloDC[1]=800;
              }
            });
          }break;

          case 5:{
            _title = "Giảm cân từ từ";
            setState(() {
              _listIcon[1] = Icons.download_sharp;
              if (_gender == "Nam"){
                goiCalo[1]=2000;
                goiCaloDC[1]=1300;
              }else {
                goiCalo[1]=1800;
                goiCaloDC[1]=1000;
              }
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
              if (_gender == "Nam"){
                goiCalo[2]=2800;
                goiCaloDC[2]=800;
              }else {
                goiCalo[2]=2500;
                goiCaloDC[2]=800;
              }
            });
          }break;

          case 3:{
            _title = "Tăng cân";
            setState(() {
              _listIcon[2] = Icons.upgrade_sharp;
              if (_gender == "Nam"){
                goiCalo[2]=2500;
                goiCaloDC[2]=1300;
              }else {
                goiCalo[2]=2300;
                goiCaloDC[2]=1000;
              }
            });
          }break;

          case 4:{
            _title = "Giữ vóc dáng";
            setState(() {
              _listIcon[2] = Icons.warning_amber_sharp;
              if (_gender == "Nam"){
                goiCalo[2]=2500;
                goiCaloDC[2]=1300;
              }else {
                goiCalo[2]=2000;
                goiCaloDC[2]=800;
              }
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
}