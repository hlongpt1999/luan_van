import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/DateMealModel.dart';
import 'package:luan_van/resources/button_back.dart';
import 'package:luan_van/resources/button_next.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/login/Login.dart';
import 'package:luan_van/screens/schedule/MockData.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateScheduleScreenState();
}

List<String> _listDate = MyList().listDate;
var _listColorTitle = MyList().listColorTitle;

List<DateMealModel> _listMeal = MockData().listMeal;

class CreateScheduleScreenState extends State<CreateScheduleScreen> {
  double _sizeHeightSchedule = 250,
      _sizeHeightItemSchedule = 240;
  double _sizeWidthItemSchedule = 300;
  double _sizeHeightTitle = 55;
  double _radiusItem = 70;
  double _sizeTextDetail = 20;
  double _sizeBox = 10;
  double initialPosition = 0.0,
      endPosition = 0.0,
      distance = 0.0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
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
        'your channel name',//Cái này hiện tên trong cài đặt
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

  // Future _showNotificationWithDefaultSound() async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', channelDescription: 'your channel description',
  //       importance: Importance.max, priority: Priority.high);
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Default Notification',
  //     'Đây là thông báo với default sound và default icon',
  //     platformChannelSpecifics,
  //     payload: 'Default_Sound',
  //   );
  // }
  //
  // Future _showNotificationWithoutSound() async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', channelDescription: 'your channel description',
  //       playSound: false, importance: Importance.max, priority: Priority.high);
  //   var iOSPlatformChannelSpecifics =
  //   new IOSNotificationDetails(presentSound: false);
  //   var platformChannelSpecifics = new NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Notification',
  //     'Đây là thông báo không có sound và default icon',
  //     platformChannelSpecifics,
  //     payload: 'No_Sound',
  //   );
  // }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Thông báo"),
          content: Text("Push Notification : $payload"),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
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
                            child: itemSchedule(_listMeal[index],
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
                          return Center(child: itemSchedule(_listMeal[index],
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

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     buttonBack("Back"),
            //
            //     Container(
            //       child: GestureDetector(
            //           onTap: (){
            //             onNextClick(context);
            //           },
            //           child: buttonNext("Next")),
            //     ),
            //   ],
            // ),


            Center(
              child: GestureDetector(
                onTap: (){
                  // testNotification();
                  onNextClick(context);
                  // _showNotificationWithoutSound();
                  // _showNotificationWithDefaultSound();

                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
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
                      "LƯU",
                      style: TextStyle(
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

  void onNextClick(BuildContext _context){
    saveSchedule();
    setState(() {
      Navigator.of(_context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  Future<void> saveSchedule() async {
    //LƯU Danh sách lại CSDL để có gì bắn thông báo

    List<String> foodName=[];
    SharedPreferences pref = await SharedPreferences.getInstance();
    for (var i = 0; i<7; i++){
      //TODO: THÊM EMAIL ĐỂ ĐỊNH NGHĨA. nhớ key để nữa lấy shared
      for (var j=0; j<_listMeal[i].foods.length ; j++){
        foodName.add(_listMeal[i].foods[j].name);
        pref.setStringList(_listMeal[i].foods[j].name, [_listMeal[i].foods[j].calo100g.toString(), _listMeal[i].foods[j].quantity.toString()]);
      }
      pref.setStringList(_listMeal[i].id.toString(), foodName);
    }
  }

  Widget itemSchedule(DateMealModel listMeal,Color _colorTitle, String _date, String _calo) {
    final rows = <TableRow>[
    TableRow(children: [
        Column(children: [Text('SL', style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
        Column(children: [Text('Thực phẩm', style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
        Column(children: [Text('Calo', style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold))
        ]),
      ]),
    ];
    for (var rowData in listMeal.foods) {
      rows.add(
        TableRow(children: [
          Column(children: [
            Text(
              rowData.quantity>=10 ? (rowData.quantity/10).toString() + "kg" : (rowData.quantity * 100).toString() + "g",
              style: TextStyle(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
          Column(children: [
            Text(
              rowData.name,
              style: TextStyle(
                fontSize: _sizeTextDetail,
              ),
            ),
          ]),
          Column(children: [
            Text(
              (rowData.calo100g * rowData.quantity).round().toString(),
              style: TextStyle(
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
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(3),
                },
                border: TableBorder.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 2),
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
                "+" + listMeal.caloDate.toString(),
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


