import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/component/LoginForm.dart';
import 'package:luan_van/resources/button_circle_max.dart';
import 'package:luan_van/screens/signup/SignUpScreen.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // Not move screen when show keyboard
      body: Container(
        decoration: new BoxDecoration(image: backgroundImage,),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoginForm(context),

              //Space between 2 TextForm.
              SizedBox(height: 30,),

              InkWell(
                onTap: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                  });
                },
                child: ButtonCircleMax(context, "Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}