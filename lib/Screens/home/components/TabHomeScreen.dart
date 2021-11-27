import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/resources/AppTheme.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';

import 'DietListView.dart';
import 'LuyenTapListView.dart';
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

            SizedBox(height: 20,),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[900],
                      Colors.blue[700],
                      Colors.blue[500],
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: MediaQuery.of(context).size.width - 40,
                child: Text(
                    "Hôm nay - "+ DateFormat("dd/M/yyyy").format(DateTime.now()),
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),

            MyTitle("Thực đơn hôm nay"),
            new DietListView(keyHomNao: 0,),

            MyTitle("Lịch tập hôm nay"),
            new LuyenTapListView(keyHomNao: 0,),
            Bar(),

            SizedBox(height: 40,),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[900],
                      Colors.blue[700],
                      Colors.blue[500],
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: MediaQuery.of(context).size.width - 40,
                child: Text(
                  "Ngày mai",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),

            CurrentUser.lichNgayMai ?
                Container(
                  child: Column(
                    children: [
                      MyTitle("Thực đơn ngày mai"),
                      new DietListView(keyHomNao: 1,),

                      MyTitle("Lịch tập ngày mai"),
                      new LuyenTapListView(keyHomNao: 1,),
                    ],
                  ),
                )
            : ngayMaiKhongCo(),

            SizedBox(height: 60,),
          ],
        ),
      ),
    );
  }

  Widget ngayMaiKhongCo(){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            "Ngày mai không có lịch",
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          SizedBox(height: 20,),

          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BMIScreen()));
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange[900],
                    Colors.orange[700],
                    Colors.orange[500],
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.create,
                    size: 25,
                    color: Colors.white,
                  ),

                  SizedBox(width: 10,),

                  Text(
                    "Tạo lịch cho ngày mai",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget MyTitle(String _text){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: MySize.paddingHor),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: MySize.paddingHor),
          alignment: Alignment.centerLeft,
          color: Colors.transparent,
          child: Text(
            _text,
            textAlign: TextAlign.left,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
              color: AppTheme.lightText,
            ),
          ),
        ),
      ],
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