import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luan_van/components/Method.dart';
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


  //TODO: Code mẫu cho hẹn giờ xử lý công việc.
  var cron = new Cron();
  // cron.schedule(new Schedule.parse('20-25-30-40 * * * *'), () async {
  //
  // });
  cron.schedule(new Schedule.parse('34 8 * * *'), () async {
    print('HELLLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
  });

  //Câu lệnh cố định màn hình không cho nó xoay ngang.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(
        MaterialApp(
          home: SplashScreen(),
        )
    );
  });
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
          CurrentUser.currentUser.name = data['name'];
          CurrentUser.currentUser.email = data['email'];
          CurrentUser.currentUser.avatar = data['avatar'];
          CurrentUser.currentUser.id = data['id'];
          CurrentUser.currentUser.role = data['role'];
          CurrentUser.currentUser.bmi = data['bmi'] ?? 0.0;
          CurrentUser.currentUser.height = data["height"] ?? 0;
          CurrentUser.currentUser.weight = data["weight"] ?? 0;
          CurrentUser.currentUser.bornYear = data["bornYear"] ?? 0;
          CurrentUser.currentUser.sex = data["sex"] ?? 0.0;
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

    var cron = new Cron();
    cron.schedule(new Schedule.parse('30 12 * * *'), () async {
      testNotification("Phút");
    });


    cron.schedule(new Schedule.parse('35 12 * * *'), () async {
      testNotification("35");
    });


    cron.schedule(new Schedule.parse('40 12 * * *'), () async {
      testNotification("40");
    });


    cron.schedule(new Schedule.parse('50 12 * * *'), () async {
      testNotification("50");
    });
  }

  Future testNotification(String detail) async {
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
      'How to Show Notification in Flutter' + detail,
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

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
                  style: TextStyle(
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
