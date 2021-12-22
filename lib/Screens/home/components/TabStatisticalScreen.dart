import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:luan_van/model/DaLamModel.dart';

class TabStatisticalScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TabStatisticalScreenState();
}

final double basicBMI = 22.5;

class TabStatisticalScreenState extends State<TabStatisticalScreen>{
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(List<TimeSeriesSales> dataCalo, List<TimeSeriesSales> dataCalo2) {
    final data = dataCalo;
    final data2 = dataCalo2;

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'TieuThu',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      ),

      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'DotChay',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data2,
      ),
    ];
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createBMIData(List<TimeSeriesSales> dataBMI, List<TimeSeriesSales> dataBasic) {
    final data = dataBMI;
    final data2 = dataBasic;

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'BMI',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      ),

      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Basic',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data2,
      ),

      new charts.Series<TimeSeriesSales, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: data)
      // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }

  List<TimeSeriesSales> caloData1 = [];
  List<TimeSeriesSales> caloData2 = [];
  List<TimeSeriesSales> bmiData = [];
  List<TimeSeriesSales> bmiBasic = [];

  Future<void> getCaloHistory() async {
    caloData1.clear();
    caloData2.clear();
    bmiData.clear();
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.COLLECTION_DALAM).orderBy('time').get().then((value){
      value.docs.forEach((element){
        var data = element.data() as Map<String, dynamic>;
        DaLamModel daLamModel = DaLamModel.fromJson(data);
        var now = daLamModel.time.toDate();
        caloData1.add(TimeSeriesSales(DateTime(now.year, now.month, now.day), daLamModel.totalFoodCalo));
        caloData2.add(TimeSeriesSales(DateTime(now.year, now.month, now.day), daLamModel.totalDongTacCalo));
      });
    });
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.COLLECTION_HISTORY_BMI).orderBy('time').get().then((value){
      value.docs.forEach((element){
        var data = element.data() as Map<String, dynamic>;
        HistoryBMI historyBMI = HistoryBMI.fromJson(data);
        var now = historyBMI.time.toDate();
        bmiData.add(TimeSeriesSales(DateTime(now.year, now.month, now.day), historyBMI.bmi));
        bmiBasic.add(TimeSeriesSales(DateTime(now.year, now.month, now.day), basicBMI));
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        color: MyColor.colorBackgroundTab,
        child: FutureBuilder(
          future: getCaloHistory(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Sự thay đổi BMI",
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),

                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 50,),
                            Container (
                              height: 2,
                              width: 30,
                              color: Colors.green,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Mức BMI hoàn hảo",
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 50,),
                            Container (
                              height: 2,
                              width: 30,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "BMI của bạn",
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 5,),

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "BMI",
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Container(
                        height: 200,
                        child: SimpleTimeSeriesChart(_createBMIData(bmiData, bmiBasic), animate: true,),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Thống kê calo",
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),

                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 50,),
                            Container (
                              height: 2,
                              width: 30,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Calo đã tiêu thụ",
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 50,),
                            Container (
                              height: 2,
                              width: 30,
                              color: Colors.red,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Calo đã đốt cháy",
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 5,),

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Số calo",
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Container(
                        height: 200,
                        child: SimpleTimeSeriesChart(_createSampleData(caloData1, caloData2), animate: true,),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),
              ],
            );
          }
        ),
      ),
    );
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    //SINGLE LINE
    // return new charts.TimeSeriesChart(
    //   seriesList,
    //   animate: animate,
    //   dateTimeFactory: const charts.LocalDateTimeFactory(),
    //   domainAxis: charts.DateTimeAxisSpec(
    //     tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
    //       day: charts.TimeFormatterSpec(
    //         format: 'dd/M',
    //         transitionFormat: 'dd/M',
    //       ),
    //     ),
    //   ),
    //   flipVerticalAxis: false,
    // );

    //DOUBLE LINE
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.LineRendererConfig(),
      customSeriesRenderers: [
        new charts.PointRendererConfig(
            customRendererId: 'customPoint')
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd/M',
            transitionFormat: 'dd/M',
          ),
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
