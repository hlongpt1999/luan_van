import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/resources/button_circle_max.dart';
import 'package:toast/toast.dart';

class ChangePasswordScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChangePasswordScreenSate();
}

class ChangePasswordScreenSate extends State<ChangePasswordScreen>{

  TextEditingController _controller = TextEditingController();
  TextEditingController _passController =TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  void onChangePassClick(){
    ProgressLoading().showLoading(context);
    String message = "";
    print(CurrentUser.currentUser.password);
    if(_controller.text == "" || _passController.text == "" || _confirmController.text == "")
      message = "Mật khẩu không được trống";
    else
    if(_controller.text == CurrentUser.currentUser.password){
      if(_passController.text == _confirmController.text){
        if(_controller.text != _passController.text){
          changePass(_passController.text);
        } else message = "Mật khẩu trùng với mật khẩu cũ";
      } else message = "Mật khẩu nhập lại không khớp";
    } else message = "Mật khẩu hiện tại không đúng";

    if(message != ""){
      ProgressLoading().hideLoading(context);
      showDialog(
        context: context,
        builder: (_context)=> AlertDialog(
          title: Text("Lỗi", style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
          ),),
          content: Text(message, style: GoogleFonts.quicksand(),),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đã hiểu", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      );
    }
  }

  Future<void> changePass(String pass) async {
    final firebaseAuth = FirebaseAuth.instance;
    print("id: "+ firebaseAuth.currentUser.uid);
    await firebaseAuth.currentUser.updatePassword(pass).then((_){
        Toast.show("Đổi mật khẩu thành công", context);
        CurrentUser.currentUser.password = pass;
        updatePass(pass);
      }).catchError((error){
        Toast.show("Không thể đổi mật khẩu vì đã xảy ra lỗi", context);
      }).whenComplete((){
      ProgressLoading().hideLoading(context);
    });
  }

  Future updatePass(String pass) async {
    await FirebaseFirestore.instance.collection(Const.CSDL_USERS).doc(CurrentUser.currentUser.id).update(
        {'password': pass}
    ).whenComplete(() => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black,)),
        backgroundColor: Colors.white,
        title: Center(child: Text("Thay đổi mật khẩu", style: GoogleFonts.quicksand(color: Colors.black, fontWeight: FontWeight.bold),)),
        actions: [
          SizedBox(width: 50,),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        color: MyColor.colorBackgroundTab,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: new EdgeInsets.symmetric(horizontal: 10.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(height: 50,),
                      //Khung user name
                      TextFormField(
                        controller: _controller,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Mật khẩu hiện tại",
                          labelText: "Mật khẩu hiện tại",
                          hintStyle: GoogleFonts.quicksand(),
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
                            Icons.password,
                            color: Colors.white,),
                        ),
                        style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                      ),

                      //Space between 2 TextForm.
                      SizedBox(height: 30,),

                      //Khung password
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Mật khẩu mới",
                          labelText: "Mật khẩu mới",
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

                      SizedBox(height: 30,),

                      //Khung password
                      TextFormField(
                        controller: _confirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Nhập lại mật khẩu mới",
                          labelText: "Nhập lại mật khẩu mới",
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
                    ],
                  )
              ),

              //Space between 2 TextForm.
              SizedBox(height: 30,),

              // Press Sign In
              InkWell(
                onTap: onChangePassClick,
                child: buttonCircleMax(context, "Lưu", color1: Colors.deepOrange, color2: Colors.orangeAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}