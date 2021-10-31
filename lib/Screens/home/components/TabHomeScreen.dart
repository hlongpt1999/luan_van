import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/resources/AppTheme.dart';

import 'DietListView.dart';
import 'MediterranesnDietView.dart';

class TabHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TabHomeScreenState();
}

class TabHomeScreenState extends State<TabHomeScreen>{


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: MyColor.colorBackgroundTab,
        child: Column(
          children: [
            new MediterranesnDietView(),

            Bar(),

            MyTitle("Thực đơn hôm nay"),
            new DietListView(),

            Bar(),

            MyTitle("Lịch tập hôm nay"),
            new DietListView(),
          ],
        ),
      ),
    );
  }

  Widget MyTitle(String _text){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: MySize.paddingHor),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Text(
        _text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          letterSpacing: 0.5,
          color: AppTheme.lightText,
        ),
      ),
    );
  }

  Widget Bar(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}