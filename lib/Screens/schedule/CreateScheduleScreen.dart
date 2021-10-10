import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/resources/button_back.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';

class CreateScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateScheduleScreenState();
}

List<String> _listDate = MyList().listDate;
var _listColorTitle = MyList().listColorTitle;

class CreateScheduleScreenState extends State<CreateScheduleScreen> {
  double _sizeHeightSchedule = 250,
      _sizeHeightItemSchedule = 240;
  double _sizeWidthItemSchedule = 300;
  double _sizeHeightTitle = 40;
  double _radiusItem = 15;
  double _sizeTextDetail = 20;
  double _sizeBox = 10;


  double initialPosition = 0.0,
      endPosition = 0.0,
      distance = 0.0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: onNextClick,),
      body: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: _sizeBox),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
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
              height: _sizeBox,
            ),

            Container(
              color: Colors.grey,
              height: _sizeHeightSchedule,
              width: double.infinity,
              child: Row(
                children: [
                  rotateTitle("Thực đơn"),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: itemSchedule(
                                _listColorTitle[index], _listDate[index],
                                "+ " + (index * 100).toString() + " calo"),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: _sizeBox,
            ),

            Container(
              color: Colors.grey,
              height: _sizeHeightSchedule,
              width: double.infinity,
              child: Row(
                children: [
                  rotateTitle("Bài tập"),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(child: itemSchedule(
                              _listColorTitle[index], _listDate[index],
                              "- " + (index * 100).toString() + " calo"),);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: _sizeBox,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buttonBack("Back"),

                Container(
                  child: GestureDetector(
                      onTap: onNextClick,
                      child: buttonNext("Next")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onNextClick(){
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  Widget itemSchedule(Color _colorTitle, String _date, String _calo) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
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
              color: _colorTitle,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(_radiusItem)),
            ),
            child: Center(
              child: Text(
                _date,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          Container(
            color: Colors.white70,
            height: _sizeHeightItemSchedule - 2 * _sizeHeightTitle,
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 2),
                children: [
                  TableRow(children: [
                    Column(children: [Text('Website', style: TextStyle(
                        fontSize: 20.0))
                    ]),
                    Column(children: [Text('Tutorial', style: TextStyle(
                        fontSize: 20.0))
                    ]),
                    Column(children: [Text('Review', style: TextStyle(
                        fontSize: 20.0))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('Flutter', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('MySQL', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Javatpoint', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('ReactJS', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                    Column(children: [Text('5*', style: TextStyle(
                        fontSize: _sizeTextDetail))
                    ]),
                  ]),
                ],
              ),
            ),
          ),

          Container(
            height: _sizeHeightTitle,
            decoration: BoxDecoration(
              color: _colorTitle,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(_radiusItem)),
            ),
            child: Center(
              child: Text(
                _calo,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
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
