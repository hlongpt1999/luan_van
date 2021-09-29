import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateScheduleScreenState();
}

class CreateScheduleScreenState extends State<CreateScheduleScreen> {
  double _sizeHeightSchedule = 250, _sizeHeightItemSchedule = 220;
  double _sizeWidthItemSchedule = 300;
  double _sizeHeightTitle = 40;
  double _radiusItem = 15;
  double _sizeTextDetail = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(35)),
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
                    "Lịch tập",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: _sizeHeightSchedule,
              width: double.infinity,
              child: Row(
                children: [
                  rotateTitle("Thực đơn"),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: itemSchedule(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemSchedule() {
    return Container(
      height: _sizeHeightItemSchedule,
      width: _sizeWidthItemSchedule,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radiusItem))
      ),
      child: Column(
        children: [
          Container(
            height: _sizeHeightTitle,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(_radiusItem)),
            ),
          ),

          Container(
            color: Colors.white70,
            height: _sizeHeightItemSchedule - 2*_sizeHeightTitle,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 2),
                children: [
                  TableRow( children: [
                    Column(children:[Text('Website', style: TextStyle(fontSize: 20.0))]),
                    Column(children:[Text('Tutorial', style: TextStyle(fontSize: 20.0))]),
                    Column(children:[Text('Review', style: TextStyle(fontSize: 20.0))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('Flutter', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('MySQL', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('Javatpoint', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('ReactJS', style: TextStyle(fontSize: _sizeTextDetail))]),
                    Column(children:[Text('5*', style: TextStyle(fontSize: _sizeTextDetail))]),
                  ]),
                ],
              ),
            ),
          ),

          Container(
            height: _sizeHeightTitle,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(_radiusItem)),
            ),
          ),
        ],
      ),
    );
  }

  Widget rotateTitle(String _title) {
    return Container(
      height: _sizeHeightSchedule,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 7,
            blurRadius: 10,
            offset: Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: Center(
          child: Text(
            _title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
