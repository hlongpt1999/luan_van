import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/screens/home/components/DietListView.dart';
import 'package:luan_van/screens/home/components/TabDanhGiaScreen.dart';
import 'package:luan_van/screens/home/components/TabHomeScreen.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:luan_van/screens/home/components/TabMessageScreen.dart';
import 'package:luan_van/screens/home/components/TabStatisticalScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../testChat.dart';
import 'components/MyDrawer.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

List<String> _bottomBarTitle = ['Trang chủ', 'Đánh giá', 'Nhắn tin', 'Thống kê'];
List<IconData> _bottomBarIcons = [
  Icons.home_outlined,
  Icons.list_alt_outlined,
  Icons.message_outlined,
  AntDesign.linechart
];

class HomeScreenState extends State<HomeScreen> {
  var title = "Tiêu đề";
  int _selectedIndex = 0;
  double _bottomTexSize = 12;
  PageController _pageController = new PageController();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  @override
  void initState() {
    title = _bottomBarTitle[0];
    super.initState();

    setUpArlam();

    var cron = new Cron();
    cron.schedule(new Schedule.parse('0,30 * * * *'), () async {
      if(CurrentUser.currentUser.role == "user") {
        await showDialog(
          context: context,
          builder: (_context) =>
              AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.yellow,),
                    SizedBox(width: 10,),
                    Text("Mẹo",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
                  ],
                ),
                content: Text(
                  MyList().listTips[Random().nextInt(MyList().listTips.length)],
                  style: GoogleFonts.quicksand(),),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Đã hiểu",
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
        );
      }
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    TabHomeScreen(),
    TabDanhGiaScreen(),
    TabMessageScreen(),
    TabStatisticalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorBackgroundTab,
      body: SliderMenuContainer(
        appBarHeight: MySize.heightAppBar,
        appBarColor: Colors.white,
        key: _key,
        sliderMenuOpenSize: MediaQuery.of(context).size.width * 3/4,
        title: Text(
          title,
          style: GoogleFonts.quicksand(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        sliderMenu: MyDrawer(),
        sliderMain: PageView(
          controller: _pageController,
          children: _widgetOptions,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
              title = _bottomBarTitle[page];
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100],
                tabs: [
                  GButton(
                    icon: _bottomBarIcons[0],
                    text: _bottomBarTitle[0],
                    textStyle: GoogleFonts.quicksand(fontSize: _bottomTexSize),
                  ),
                  GButton(
                    icon: _bottomBarIcons[1],
                    text: _bottomBarTitle[1],
                    textStyle: GoogleFonts.quicksand(fontSize: _bottomTexSize),
                  ),
                  GButton(
                    icon: _bottomBarIcons[2],
                    text: _bottomBarTitle[2],
                    textStyle: GoogleFonts.quicksand(fontSize: _bottomTexSize),
                  ),
                  GButton(
                    icon: _bottomBarIcons[3],
                    text: _bottomBarTitle[3],
                    textStyle: GoogleFonts.quicksand(fontSize: _bottomTexSize),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.jumpToPage(index);
                    title = _bottomBarTitle[index];
                  });
                }),
          ),
        ),
      ),
    );
  }



  Future<void> daLam() async {
    flutterLocalNotificationsPlugin.show(
      2,
      "Hôm nay bạn đã làm được gì.",
      "Tổng kết xem hôm nay bạn đã ăn uống và luyện tập như thế nào.",
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher')
      ),
      payload: 'Custom_Sound',
    );
  }


  Future<void> nhacNho() async {
    flutterLocalNotificationsPlugin.show(
      0,
      "Bắt đầu một ngày mới.",
      "Xem lịch ăn uống và tâp luyện ngày hôm nay thôi nào.",
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher')
      ),
      payload: 'Custom_Sound',
    );
  }

  Future setUpArlam() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> list = pref.getStringList(Const.KEY_DAT_GIO) ?? ["null"];
    if(list[0] != "null"){
      CurrentUser.lichNhacNho = list[0] == "true" ? true : false;
      CurrentUser.nhacNhoGIO = int.parse(list[1]);
      CurrentUser.nhacNhoPHUT= int.parse(list[2]);
      CurrentUser.lichDaLam = list[3] == "true" ? true : false;
      CurrentUser.daLamGIO = int.parse(list[4]);
      CurrentUser.daLamPHUT= int.parse(list[5]);
    }

    if(CurrentUser.lichNhacNho)
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24), //Do the same every 24 hours
        123, //Different ID for each alarm
        nhacNho,
        wakeup: true, //the device will be woken up when the alarm fires
        startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, CurrentUser.nhacNhoGIO, CurrentUser.nhacNhoPHUT), //Start whit the specific time 5:00 am
        rescheduleOnReboot: true, //Work after reboot
      );

    if(CurrentUser.lichDaLam)
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24), //Do the same every 24 hours
        456, //Different ID for each alarm
        daLam,
        wakeup: true, //the device will be woken up when the alarm fires
        startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, CurrentUser.daLamGIO, CurrentUser.daLamPHUT), //Start whit the specific time 5:00 am
        rescheduleOnReboot: true, //Work after reboot
      );
  }
}


