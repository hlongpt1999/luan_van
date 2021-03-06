import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/Method.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/DateLuyenTapModel.dart';
import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/resources/button_back.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/login/Login.dart';
import 'package:luan_van/screens/schedule/MockData.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:toast/toast.dart';

class CreateScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateScheduleScreenState();
}

List<String> _listDate = MyList().listDate;
var _listColorTitle = MyList().listColorTitle;

class CreateScheduleScreenState extends State<CreateScheduleScreen> {

  List<DateMealModel> _listMeal = MockData.listMeal2;
  List<DateLuyenTapModel> _listLuyenTap = MockData.listLuyenTap;
  double _sizeHeightSchedule = 250,
      _sizeHeightItemSchedule = 240;
  double _sizeWidthItemSchedule = 300;
  double _sizeHeightTitle = 55;
  double _radiusItem = 70;
  double _sizeTextDetail = 16;
  double _sizeBox = 10;
  double initialPosition = 0.0,
      endPosition = 0.0,
      distance = 0.0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    _listMeal = MockData.listMeal2;
    List<DateLuyenTapModel> _listLuyenTap = MockData.listLuyenTap;
    var initializationSettingsAndroid =  new AndroidInitializationSettings('eaten');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future testNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id',
        'your channel name',//C??i n??y hi???n t??n trong c??i ?????t
        channelDescription: "your channel description",
        sound: RawResourceAndroidNotificationSound("noti"),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        icon: "eaten",
      );

    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      5,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );

    // DateTime schedule = DateTime.now().add(Duration(seconds: 1));
    // await flutterLocalNotificationsPlugin.zonedSchedule(0, "test" ,"testda", schedule, platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Th??ng b??o"),
          content: Text("Push Notification : $payload"),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: foodLoadingBackground,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    "L???ch t???p",
                    style: GoogleFonts.quicksand(
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
              color: Colors.transparent,
              height: _sizeHeightSchedule,
              width: double.infinity,
              child: Row(
                children: [
                  rotateTitle("Th???c ????n"),
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
                            child: itemSchedule(_listMeal[index],
                                _listColorTitle[index], _listDate[index]),
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
              color: Colors.transparent,
              height: _sizeHeightSchedule,
              width: double.infinity,
              child: Row(
                children: [
                  rotateTitle("B??i t???p"),
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
                              child: itemScheduleLuyenTap(_listLuyenTap[index],
                              _listColorTitle[index], _listDate[index]),
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

            Center(
              child: GestureDetector(
                onTap: (){
                  // testNotification();
                  onNextClick(context);
                },
                child: Container(
                  padding: EdgeInsets.only(top: _sizeBox),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
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
                      "L??U",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Bi???n l??u h??m nay ho???c ng??y mai
  Future<void> uploadSchedule(BuildContext _context) async{
    for(int i =0; i<7;i++){
      if(CurrentUser.taoLichChoNgayMai)
        i++;

      DateMealModel dateMealModel = _listMeal[i];
      DateLuyenTapModel dateLuyenTapModel = _listLuyenTap[i];

      //Set th???i gian l?? 12h t??? nay t???i 7 ng??y.
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day + i, 12, 0, 0, 0, 0);
      dateMealModel.time = Timestamp.fromDate(today);
      dateLuyenTapModel.time = Timestamp.fromDate(today);

      await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
          .collection("schedule").add(dateMealModel.toMap()
      ).onError((error, stackTrace){
        ProgressLoading().hideLoading(context);
        Toast.show("???? x???y ra l???i, vui l??ng th??? l???i", context);
      });

      await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
          .collection("scheduleLuyenTap").add(dateLuyenTapModel.toMap()
      ).onError((error, stackTrace){
        ProgressLoading().hideLoading(context);
        Toast.show("???? x???y ra l???i, vui l??ng th??? l???i", context);
      });
    }
    //L???y l???ch ????? hi???n th???.
    getSchedule(CurrentUser.currentUser.id, context);
  }

  void onNextClick(BuildContext _context){
    ProgressLoading().showLoading(context);
    timLichCu(_context);
  }

  List<String> idLichCu = [];
  List<String> idLichCu2 = [];
  Future<void> timLichCu(BuildContext _context) async {
    idLichCu.clear();
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.CSDL_SCHEDULE).get().then((value){
      value.docs.forEach((element){
        var data = element.data() as Map<String, dynamic>;
        var id = element.id;
        Timestamp time = data['time'];
        if(now.year<time.toDate().year){
          idLichCu.add(id);
        } else if (now.year == time.toDate().year){
          if(now.month<time.toDate().month){
            idLichCu.add(id);
          } else if (now.month == time.toDate().month){
            if(now.day<time.toDate().day){
              idLichCu.add(id);
            }
            if(now.day==time.toDate().day && !CurrentUser.taoLichChoNgayMai){
              idLichCu.add(id);
            }
          }
        }
      });
    }).whenComplete(() => xoaLichCu(_context));

    idLichCu2.clear();
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
        .collection(Const.CSDL_SCHEDULE_LUYENTAP).get().then((value){
      value.docs.forEach((element){
        var data = element.data() as Map<String, dynamic>;
        var id = element.id;
        Timestamp time = data['time'];
        if(now.year<time.toDate().year){
          idLichCu2.add(id);
        } else if (now.year == time.toDate().year){
          if(now.month<time.toDate().month){
            idLichCu2.add(id);
          } else if (now.month == time.toDate().month){
            if(now.day<time.toDate().day){
              idLichCu2.add(id);
            }
            if(now.day==time.toDate().day && !CurrentUser.taoLichChoNgayMai){
              idLichCu2.add(id);
            }
          }
        }
      });
    }).whenComplete(() => xoaLichCu2(_context));
  }

  Future xoaLichCu(BuildContext _context) async {
    for (int i=0 ; i<idLichCu.length; i++){
      await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
          .collection(Const.CSDL_SCHEDULE).doc(idLichCu[i]).delete();
    }
  }

  Future xoaLichCu2(BuildContext _context) async {
    for (int i=0 ; i<idLichCu2.length; i++){
      await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id)
          .collection(Const.CSDL_SCHEDULE_LUYENTAP).doc(idLichCu2[i]).delete();
    }
    uploadSchedule(_context);
  }

  Widget itemSchedule(DateMealModel listMeal,Color _colorTitle, String _date) {
    final rows = <TableRow>[
    TableRow(children: [
        Column(children: [Text('SL', style: GoogleFonts.quicksand(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
        Column(children: [Text('Th???c ph???m', style: GoogleFonts.quicksand(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
        Column(children: [Text('Calo', style: GoogleFonts.quicksand(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
      ]),
    ];
    for (var rowData in listMeal.foods) {
      rows.add(
        TableRow(children: [
          Column(children: [
            Text(
              rowData.quantity != null
              ? (rowData.quantity>=1000 ? (rowData.quantity/1000).toString() + "kg" : rowData.quantity.toString() + "g")//TODO
              : "gi?? tr??? null",
              style: GoogleFonts.quicksand(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
          Column(children: [
            Text(
              rowData.name,
              style: GoogleFonts.quicksand(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
          Column(children: [
            Text(
              (rowData.calo100g!=null && rowData.quantity!=null)
              ? ((rowData.calo100g * rowData.quantity/100).round().toString())//TODO
              : "Gi?? tr??? null",
              style: GoogleFonts.quicksand(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
        ]),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: _sizeHeightItemSchedule,
      width: _sizeWidthItemSchedule,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radiusItem),
            topRight: Radius.circular(_radiusItem),
            bottomRight: Radius.circular(_radiusItem),
          )
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
                style: GoogleFonts.quicksand(
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
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(3),
                },
                // border: TableBorder.all(
                //     color: Colors.black,
                //     style: BorderStyle.solid,
                //     width: 0),
                children: rows,
              ),
            ),
          ),

          Container(
            height: _sizeHeightTitle,
            decoration: BoxDecoration(
              color: _colorTitle,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(_radiusItem)),
            ),
            child: Center(
              child: Text(
                "+" + listMeal.caloDate.toString() +" Calo",
                style: GoogleFonts.quicksand(
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

  Widget itemScheduleLuyenTap(DateLuyenTapModel listLuyenTap,Color _colorTitle, String _date) {
    final rows = <TableRow>[
      TableRow(children: [
        Column(children: [Text('L???n', style: GoogleFonts.quicksand(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
        Column(children: [Text('?????ng t??c', style: GoogleFonts.quicksand(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
        Column(children: [Text('Ti??u th???', style: GoogleFonts.quicksand(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
      ]),
    ];
    for (var rowData in listLuyenTap.dongTac) {
      rows.add(
        TableRow(children: [
          Column(children: [
            Text(
              rowData.quantity != null
                  ? rowData.quantity.toString() + rowData.donvi
                  : "gi?? tr??? null",
              style: GoogleFonts.quicksand(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
          Column(children: [
            Text(
              rowData.name,
              style: GoogleFonts.quicksand(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
          Column(children: [
            Text(
              (rowData.caloLost100g!=null && rowData.quantity!=null)
                  ? ((rowData.caloLost100g * rowData.quantity).round().toString())
                  : "Gi?? tr??? null",
              style: GoogleFonts.quicksand(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
        ]),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: _sizeHeightItemSchedule,
      width: _sizeWidthItemSchedule,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radiusItem),
            topRight: Radius.circular(_radiusItem),
            bottomRight: Radius.circular(_radiusItem),
          )
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
                style: GoogleFonts.quicksand(
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
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(3),
                },
                // border: TableBorder.all(
                //     color: Colors.black,
                //     style: BorderStyle.solid,
                //     width: 0),
                children: rows,
              ),
            ),
          ),

          Container(
            height: _sizeHeightTitle,
            decoration: BoxDecoration(
              color: _colorTitle,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(_radiusItem)),
            ),
            child: Center(
              child: Text(
                "-" + listLuyenTap.caloDate.toString()+" Calo",
                style: GoogleFonts.quicksand(
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
            style: GoogleFonts.quicksand(
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


