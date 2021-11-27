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

class TabStatisticalScreenState extends State<TabStatisticalScreen>{
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(List<TimeSeriesSales> dataCalo) {
    // final data = [
    //   new TimeSeriesSales(new DateTime(2017, 9, 19), 4.5),
    //   new TimeSeriesSales(new DateTime(2017, 9, 26), 10),
    //   new TimeSeriesSales(new DateTime(2017, 10, 3), 15),
    //   new TimeSeriesSales(new DateTime(2017, 10, 15), 20),
    //   new TimeSeriesSales(new DateTime(2017, 10, 16), 20.1),
    //   new TimeSeriesSales(new DateTime(2017, 10, 17), 20.5),
    //   new TimeSeriesSales(new DateTime(2017, 10, 18), 5),
    //   new TimeSeriesSales(new DateTime(2017, 10, 19), 20),
    //   new TimeSeriesSales(new DateTime(2017, 10, 20), 20),
    // ];

    final data = dataCalo;

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  List<TimeSeriesSales> caloData1 = [];
  List<TimeSeriesSales> caloData2 = [];

  Future<void> getCaloHistory() async {
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection("historyDaLam").get().then((value){
      value.docs.forEach((element){
        var data = element.data() as Map<String, dynamic>;
        DaLamModel daLamModel = DaLamModel.fromJson(data);
        var now = daLamModel.time.toDate();
        caloData1.add(TimeSeriesSales(DateTime(now.year, now.month, now.day), daLamModel.totalFoodCalo));
        caloData2.add(TimeSeriesSales(DateTime(now.year, now.month, now.day), daLamModel.totalDongTacCalo));
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
                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.all(Radius.circular(20)),
                //   ),
                //   child: Column(
                //     children: [
                //       Center(
                //         child: Text(
                //           "Sự thay đổi BMI",
                //           style: GoogleFonts.quicksand(
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 20,),
                //
                //       Container(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           "BMI",
                //           style: GoogleFonts.quicksand(
                //             fontSize: 13,
                //           ),
                //         ),
                //       ),
                //
                //       Container(
                //         height: 300,
                //         child: SimpleTimeSeriesChart(_createSampleData(), animate: true,),
                //       ),
                //     ],
                //   ),
                // ),
                //
                // SizedBox(height: 30,),

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
                          "Calo tiêu thụ trong tuần",
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

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
                          child: SimpleTimeSeriesChart(_createSampleData(caloData1), animate: true,),
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
                          "Calo đốt cháy trong tuần",
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

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
                        child: SimpleTimeSeriesChart(_createSampleData(caloData2), animate: true,),
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

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  // factory SimpleTimeSeriesChart.withSampleData() {
  //   return new SimpleTimeSeriesChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
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

  /// Create one series with sample hard coded data.
  // static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
  //   final data = [
  //     new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
  //     new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
  //     new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
  //     new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
  //   ];
  //
  //   return [
  //     new charts.Series<TimeSeriesSales, DateTime>(
  //       id: 'Sales',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (TimeSeriesSales sales, _) => sales.time,
  //       measureFn: (TimeSeriesSales sales, _) => sales.sales,
  //       data: data,
  //     )
  //   ];
  // }
}

class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
