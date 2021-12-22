import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/Method.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/components/response_widget.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/resources/shape_clipper_custom.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/resources/button_circle_max.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/home/DoctorHomeScreen.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:luan_van/screens/signup/SignUpScreen.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  var _userErrorMessage = "Tài khoản không tồn tại";
  var _passErrorMessage = "Mật khẩu không hợp lệ";
  var _isUserError = false;
  var _isPassError = false;

  bool showPass = false;

  UserModel userModel = UserModel();

  final _firebaseAuth = FirebaseAuth.instance;
  Future getData(String uid) async {
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(uid).get().then((value){
      var data = value.data() as Map<String, dynamic>;
      CurrentUser.currentUser.name = data['name'];
      CurrentUser.currentUser.email = data['email'];
      CurrentUser.currentUser.avatar = data['avatar'] ?? "";
      CurrentUser.currentUser.password = data['password'] ?? "";
      CurrentUser.currentUser.id = data['id'];
      CurrentUser.currentUser.role = data['role'] ?? "user";
      CurrentUser.currentUser.bmi = data['bmi'] ?? 0.0000000000000001;
      CurrentUser.currentUser.height = data["height"] ?? 165;
      CurrentUser.currentUser.weight = data["weight"] ?? 50;
      CurrentUser.currentUser.bornYear = data["bornYear"] ?? 0;
      CurrentUser.currentUser.sex = data["sex"] ?? 0.0;
      CurrentUser.currentUser.phone = data["phone"] ?? 0;
      CurrentUser.currentUser.address = data["address"] ?? "";
      // CurrentUser.currentUser = UserModel.fromJson(data);
    });
  }

  Future handleSignIn(String email, String pass) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setStringList(Const.LOGIN_PREF, [value.user.uid, email, pass]);
        _isUserError = false;
        _isPassError = false;
        await getData(value.user.uid).whenComplete(() async{
          if(CurrentUser.currentUser.role != "user" ){
            // print("Role="+CurrentUser.currentUser.role);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DoctorHomeScreen()));
          }
          else if(CurrentUser.currentUser.bmi < 2.0)
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BMIScreen()));
          else
            getSchedule(CurrentUser.currentUser.id, context);
        });
      });
    }on FirebaseAuthException catch (error){
      switch(error.code){
        case 'user-not-found':
          ProgressLoading().hideLoading(context);
          Toast.show('Tài khoản không tồn tại', context);
          _isUserError = true;
          break;
        case 'invalid-email':
          ProgressLoading().hideLoading(context);
          Toast.show('Tài khoản không tồn tại', context);
          _isUserError = true;
          break;
        case 'wrong-password':
          ProgressLoading().hideLoading(context);
          Toast.show('Mật khẩu sai', context);
          _isPassError = true;
          break;
        default:
          ProgressLoading().hideLoading(context);
          Toast.show("Lỗi khi đăng nhập", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    var _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    var _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      resizeToAvoidBottomInset: false, // Not move screen when show keyboard
      body: Container(
        // decoration: new BoxDecoration(image: backgroundImage,),
        color: Colors.white,
        child: Column(
          children: [
            headerPaint(_large, _height, _medium),

            Center(
              child: Container(
                height: _height/2,
                width: _width - 30,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: new EdgeInsets.symmetric(horizontal: 20.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //Khung user name
                            TextFormField(
                              controller: _userController,
                              decoration: InputDecoration(
                                hintText: "Tên đăng nhập",
                                labelText: "Tên đăng nhập",
                                hintStyle: GoogleFonts.quicksand(),
                                errorText: _isUserError ? _userErrorMessage : null,
                                labelStyle: GoogleFonts.quicksand(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(20))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(20))
                                ),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,),
                              ),
                              style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                            ),

                            //Space between 2 TextForm.
                            SizedBox(height: 30,),

                            //Khung password
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextFormField(
                                  controller: _passController,
                                  obscureText: !showPass,
                                  decoration: InputDecoration(
                                    hintText: "Mật khẩu",
                                    labelText: "Mật khẩu",
                                    errorText: _isPassError ? _passErrorMessage : null,
                                    labelStyle: GoogleFonts.quicksand(color: Colors.white),
                                    hintStyle: GoogleFonts.quicksand(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(20))
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(20))
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white),
                                  ),
                                  style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                                ),
                                
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: showPass
                                      ? Icon(Icons.visibility_off_outlined, color: Colors.white)
                                      : Icon(Icons.visibility_outlined, color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),

                    //Space between 2 TextForm.
                    SizedBox(height: 30,),

                    // Press Sign In
                    InkWell(
                      onTap: onSignInClick,
                      child: buttonCircleMax(context, "Đăng nhập", color1: Colors.deepOrange, color2: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: MySize.paddingHor),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              // padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.18),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: buttonCircleMax(context, "Tạo tài khoản", color1: Colors.grey[400], color2: Colors.blueGrey, colorText: Colors.white),
                ),
              ),

            SizedBox(height: 20),
            Text(Const.VERSION, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          ],
        ),
      ),
    );
  }

  void onSignInClick(){
    setState(() {
      handleSignIn(_userController.text, _passController.text);
      ProgressLoading().showLoading(context);
    });
  }

  Widget headerPaint(var _large, var _height, var _medium){
    return Container(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.75,
            child: ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                height: _large? _height/2 : (_medium? _height/2 : _height/4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[200], Colors.pinkAccent],
                  ),
                ),
              ),
            ),
          ),


          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: CustomShapeClipper2(),
              child: Container(
                height: _large? _height/7 : (_medium? _height/6 : _height/7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[200], Colors.pinkAccent],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}