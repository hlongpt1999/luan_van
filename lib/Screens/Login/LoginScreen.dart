import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/resources/button_circle_max.dart';
import 'package:luan_van/screens/bmi/BMIScreen.dart';
import 'package:luan_van/screens/signup/SignUpScreen.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  //TODO: Message login
  var _userErrorMessage = "User name is not exist";
  var _passErrorMessage = "Invalid password";
  var _isUserError = false;
  var _isPassError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Not move screen when show keyboard
      body: Container(
        decoration: new BoxDecoration(image: backgroundImage,),
        child: Center(
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
                          hintText: "User name",
                          labelText: "User Name",
                          // errorText: _isUserError ? _userErrorMessage : null,
                          labelStyle: TextStyle(color: Colors.white),
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
                        style: TextStyle(fontSize: 20),
                      ),

                      //Space between 2 TextForm.
                      SizedBox(height: 30,),

                      //Khung password
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          // errorText: _isPassError ? _passErrorMessage : null,
                          labelStyle: TextStyle(color: Colors.white),
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
                            color: Colors.white,),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
              ),

              //Space between 2 TextForm.
              SizedBox(height: 30,),

              // Press Sign In
              InkWell(
                onTap: onSignInClick,
                child: buttonCircleMax(context, "Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSignInClick(){
    setState(() {
      handleSignIn(_userController.text, _passController.text);
    });
  }

  void handleSignIn(String username, String password){
    setState(() {
      //TODO: Xử lý đăng nhập thành công.
      if (username=="a" && password=="a"){
        _isUserError = false;
        _isPassError = false;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BMIScreen()));
      }  else{
        _isUserError = true;
        _isPassError = true;
        new AlertDialog(
            title: const Text("Error"),
            content: const Text("Wrong pass & user"),
            actions: [
              new FlatButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
              new FlatButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
        );
      }
    });
  }

}