import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luan_van/ThemFood.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/signup/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/Constants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'screens/login/LoginScreen.dart';
import 'dart:math' as math;

void main() {
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
        await FirebaseFirestore.instance.collection('users').doc(login.elementAt(0)).get().then((value) async{
          var data = value.data() as Map<String, dynamic>;
          CurrentUser.currentUser.name = data['name'];
          CurrentUser.currentUser.email = data['email'];
          CurrentUser.currentUser.avatar = data['avatar'];
          CurrentUser.currentUser.id = data['id'];
          CurrentUser.currentUser.role = data['role'];
        });
        // runApp(
        //     new MaterialApp(
        //       home: HomeScreen(),
        //     )
        // );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }).onError((error, stackTrace){
        // runApp(
        //     new MaterialApp(
        //       home: LoginScreen(),
        //     )
        // );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }else {
      // runApp(
      //     new MaterialApp(
      //       home: LoginScreen(),
      //     )
      // );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      handleSignIn();
    });
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
