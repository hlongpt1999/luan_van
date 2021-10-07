import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/resources/button_radius_medium.dart';

class ScheduleDetailScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ScheduleDetailScreenState();
  }
}

List<String> _listDate = MyList().listDate;
var _listColorTitle = MyList().listColorTitle;

class ScheduleDetailScreenState extends State<ScheduleDetailScreen>{
  double _marginBottom = 30;
  double _marginHor = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children:[
            PageView(
              children: [
                for (int i=0; i<7 ;i++)
                  ScheduleDetailPage(_listColorTitle[i], _listDate[i]),
              ],
            ),

            Container(
              padding: EdgeInsets.only(left: _marginHor, bottom: _marginBottom),
              alignment: Alignment.bottomLeft,
                child: buttonRadiusMedium("Hủy", Colors.red)
            ),

            Container(
                padding: EdgeInsets.only(right: _marginHor, bottom: _marginBottom),
                alignment: Alignment.bottomRight,
                child: buttonRadiusMedium("Lưu", Colors.green)
            ),
          ],
        ),
      ),
    );
  }

  Widget ScheduleDetailPage(Color _color, String _date){
    return Container(
      color: _color,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height - 300,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 30),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
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
                _date,
                style: TextStyle(
                  color: _color,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}