import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Method.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/screens/data/ThemFood.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/bmi/EvaluateBMIScreen.dart';
import 'package:luan_van/screens/home/DoctorHomeScreen.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/login/Login.dart';
import 'package:luan_van/screens/schedule/CreateScheduleScreen.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';
import 'package:luan_van/screens/signup/SignUpScreen.dart';
import 'package:luan_van/testChat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/Constants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'screens/login/LoginScreen.dart';
import 'dart:math' as math;
import 'package:cron/cron.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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

  //C??u l???nh c??? ?????nh m??n h??nh kh??ng cho n?? xoay ngang.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await AndroidAlarmManager.initialize();
    runApp(
        MaterialApp(
          home: SplashScreen(),
        )
    );
    await AndroidAlarmManager.periodic(
      const Duration(seconds: 45), //Do the same every 24 hours
      123, //Different ID for each alarm
      nhacNho,
      wakeup: true, //the device will be woken up when the alarm fires
      // startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, CurrentUser.nhacNhoGIO, CurrentUser.nhacNhoPHUT), //Start whit the specific time 5:00 am
      rescheduleOnReboot: true, //Work after reboot
    );

    await AndroidAlarmManager.periodic(
      const Duration(minutes: 45), //Do the same every 24 hours
      456, //Different ID for each alarm
      daLam,
      wakeup: true, //the device will be woken up when the alarm fires
      // startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, CurrentUser.daLamGIO, CurrentUser.daLamPHUT), //Start whit the specific time 5:00 am
      rescheduleOnReboot: true, //Work after reboot
    );
  });
}

Future<void> nhacNho() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> list = await pref.getStringList(Const.KEY_DAT_GIO) ?? ["null"];
  DateTime now = DateTime.now();
  print("nhac");

  if(list[0] != "null" && list[0] == "true")
  {
    if(now.hour.toString() == list[1] && now.minute.toString() == list[2])
    {
      print("nhacNho");
      flutterLocalNotificationsPlugin.show(
        0,
        "B???t ?????u m???t ng??y m???i.",
        "Xem l???ch ??n u???ng v?? t??p luy???n ng??y h??m nay.",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
                color: Colors.blue,
                playSound: true,
                styleInformation: BigTextStyleInformation(''),
                icon: '@mipmap/ic_launcher')
        ),
        payload: 'Custom_Sound',
      );
    }
  }
}

Future<void> daLam() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> list = await pref.getStringList(Const.KEY_DAT_GIO) ?? ["null"];
  DateTime now = DateTime.now();
  print("da");

  if(list[3] != "null" && list[3] == "true")
  {
    if(now.hour.toString() == list[4] && now.minute.toString() == list[5])
    {
      print("daLam");
      flutterLocalNotificationsPlugin.show(
        2,
        "H??m nay b???n ???? l??m ???????c g???",
        "?????ng qu??n t???ng k???t h??m nay.",
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
  }
}

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  Future<void> handleSignIn() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> login = pref.getStringList(Const.LOGIN_PREF);
    final _firebaseAuth = FirebaseAuth.instance;

    if(login != null){
      var email = login.elementAt(1);
      var pass = login.elementAt(2);

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass)
          .then((value) async{
        await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(login.elementAt(0)).get().then((value) async{
          var data = value.data() as Map<String, dynamic>;
          // CurrentUser.currentUser.name = data['name'];
          // CurrentUser.currentUser.email = data['email'];
          // CurrentUser.currentUser.avatar = data['avatar'];
          // CurrentUser.currentUser.password = data['password'] ?? "";
          // CurrentUser.currentUser.id = data['id'];
          // CurrentUser.currentUser.role = data['role'];
          // CurrentUser.currentUser.bmi = data['bmi'] ?? 0.0;
          // CurrentUser.currentUser.height = data["height"] ?? 0;
          // CurrentUser.currentUser.weight = data["weight"] ?? 0;
          // CurrentUser.currentUser.bornYear = data["bornYear"] ?? 0;
          // CurrentUser.currentUser.sex = data["sex"] ?? 0.0;
          CurrentUser.currentUser = UserModel.fromJson(data);
        });
        if(CurrentUser.currentUser.role != "user" )
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DoctorHomeScreen()));
        else if(CurrentUser.currentUser.bmi < 2)
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BMIScreen()));
        else
          getSchedule(CurrentUser.currentUser.id, context);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

      }).onError((error, stackTrace){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      handleSignIn();
    });

    super.initState();
    var initializationSettingsAndroid =  new AndroidInitializationSettings('eaten');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Colors.orange,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Center(
                child: Transform.rotate(
                  angle: 45 * math.pi / 180,
                  child: Container(
                    height: MediaQuery.of(context).size.width/2,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.white,
                          Colors.purple,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )
                ),
              ),

              Center(
                child: Text(
                  "DiEx",
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width/4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
