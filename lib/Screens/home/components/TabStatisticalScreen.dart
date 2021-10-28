import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:fl_chart/fl_chart.dart';

class TabStatisticalScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TabStatisticalScreenState();
}

class TabStatisticalScreenState extends State<TabStatisticalScreen>{

  List<LineChartModel> data = [
    LineChartModel(amount: 300, date: DateTime(2020, 1, 1)),
    LineChartModel(amount: 200, date: DateTime(2020, 1, 2)),
    LineChartModel(amount: 300, date: DateTime(2020, 1, 3)),
    LineChartModel(amount: 500, date: DateTime(2020, 1, 4)),
    LineChartModel(amount: 800, date: DateTime(2020, 1, 5)),
    LineChartModel(amount: 200, date: DateTime(2020, 1, 6)),
    LineChartModel(amount: 120, date: DateTime(2020, 1, 7)),
    LineChartModel(amount: 140, date: DateTime(2020, 1, 8)),
    LineChartModel(amount: 110, date: DateTime(2020, 1, 9)),
    LineChartModel(amount: 250, date: DateTime(2020, 1, 10)),
    LineChartModel(amount: 390, date: DateTime(2020, 1, 11)),
    LineChartModel(amount: 1300, date: DateTime(2020, 1, 12)),
  ];

  List<LineChartData> data2 = [
  ];

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      data = [
        LineChartModel(amount: 500, date: DateTime(2020, 1, 4)),
        LineChartModel(amount: 200, date: DateTime(2020, 1, 2)),
        LineChartModel(amount: 200, date: DateTime(2020, 1, 6)),
        LineChartModel(amount: 800, date: DateTime(2020, 1, 5)),
        LineChartModel(amount: 1300, date: DateTime(2020, 1, 12)),
        LineChartModel(amount: 300, date: DateTime(2020, 1, 3)),
        LineChartModel(amount: 120, date: DateTime(2020, 1, 7)),
        LineChartModel(amount: 250, date: DateTime(2020, 1, 10)),
        LineChartModel(amount: 140, date: DateTime(2020, 1, 8)),
        LineChartModel(amount: 100, date: DateTime(2020, 1, 1)),
        LineChartModel(amount: 390, date: DateTime(2020, 1, 11)),
        LineChartModel(amount: 110, date: DateTime(2020, 1, 9)),
        LineChartModel(amount: 410, date: DateTime(2020, 4, 9)),
      ];
    });
  }


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        color: MyColor.colorBackgroundTab,
        child: Column(
          children: [
            // sample1(context),
            // sample2(context),
            // sample3(context),
          ],
        ),
      ),
    );
  }
  Paint circlePaint = Paint()..color = Colors.black;

  Paint insideCirclePaint = Paint()..color = Colors.white;

  Paint linePaint = Paint()
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke
    ..color = Colors.black;


  // Widget sample1(BuildContext context) {
  //   return Center(
  //     child: LineChart(
  //       width: MediaQuery.of(context).size.width,
  //       height: 180,
  //       data: data,
  //       linePaint: linePaint,
  //       circlePaint: circlePaint,
  //       showPointer: true,
  //       showCircles: false,
  //       customDraw: (Canvas canvas, Size size) {},
  //       linePointerDecoration: BoxDecoration(
  //         color: Colors.black,
  //       ),
  //       pointerDecoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.black,
  //       ),
  //       insideCirclePaint: insideCirclePaint,
  //       onValuePointer: (LineChartModelCallback value) {
  //         print('${value.chart} ${value.percentage}');
  //       },
  //       onDropPointer: () {
  //         print('onDropPointer');
  //       },
  //     ),
  //   );
  // }
  //
  // Widget sample2(BuildContext context){
  //   return LineChart(
  //     width: MediaQuery.of(context).size.width,
  //     height: 180,
  //     data: data,
  //     linePaint: linePaint,
  //     circlePaint: circlePaint,
  //     showPointer: true,
  //     showCircles: false,
  //     customDraw: (Canvas canvas, Size size) {},
  //     linePointerDecoration: BoxDecoration(
  //       color: Colors.black,
  //     ),
  //     pointerDecoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: Colors.black,
  //     ),
  //     insideCirclePaint: insideCirclePaint,
  //     onValuePointer: (LineChartModelCallback value) {
  //       print('${value.chart} ${value.percentage}');
  //     },
  //     onDropPointer: () {
  //       print('onDropPointer');
  //     },
  //   );
  // }
  //
  // Widget sample3(BuildContext context){
  //   return Container(
  //     child: LineChart(
  //       width: MediaQuery.of(context).size.width,
  //       height: 180,
  //       data: data,
  //       linePaint: linePaint,
  //       circlePaint: circlePaint,
  //       showPointer: false,
  //       showCircles: false,
  //       customDraw: (Canvas canvas, Size size) {},
  //       linePointerDecoration: BoxDecoration(
  //         color: Colors.black,
  //       ),
  //       pointerDecoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.black,
  //       ),
  //       insideCirclePaint: insideCirclePaint,
  //       onValuePointer: (LineChartModelCallback value) {
  //         print('${value.chart} ${value.percentage}');
  //       },
  //       onDropPointer: () {
  //         print('onDropPointer');
  //       },
  //     ),
  //   );
  // }

}