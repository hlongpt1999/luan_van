import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/response_widget.dart';
import 'package:luan_van/firebase/auth_firebase.dart';
import 'package:luan_van/model/User.dart';
import 'package:luan_van/resources/button_radius_big.dart';
import 'package:luan_van/resources/button_radius_medium.dart';
import 'package:luan_van/resources/shape_clipper_custom.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/resources/text_field_custom.dart';
import 'package:luan_van/screens/login/LoginScreen.dart';
import 'package:toast/toast.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUpScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>{
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _passConfirmController = TextEditingController();

  final firebase = FirebaseDatabase.instance;
  final firebaseAuth = FirebaseAuth.instance;

  PickedFile _image = PickedFile("");

  Future createUser() async{
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      ).then(
              (value) async {
            await postDataFireStore();
          }
      );
      } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ProgressLoading().hideLoading(context);
        Toast.show("M???t kh???u ??t nh???t 6 k?? t???", context);
      } else if (e.code == 'email-already-in-use') {
        ProgressLoading().hideLoading(context);
        Toast.show("T??i kho???n ???? t???n t???i", context);
      }
    } catch (e) {
      print(e);
    }
  }

  Future postDataFireStore() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = firebaseAuth.currentUser;
    UserModel userModel = UserModel();
    userModel.id = user.uid;
    userModel.name = _nameController.text;
    userModel.email = _emailController.text;

    if(_image.path != "") {
      String avatar = 'avatars/' + user.uid + '.png';
      userModel.avatar = avatar;
      uploadFile(avatar);
    }
    await firebaseFirestore.collection('users').doc(userModel.id).set(userModel.toMap());
    Toast.show('???? th??m th??nh c??ng t??i kho???n: ' + _nameController.text, context);
    ProgressLoading().hideLoading(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }

  Future chooseFile() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future uploadFile(String fileName) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(fileName)
          .putFile(File(_image.path));
    } on FirebaseException catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 35,),
                clipShape(),
                form(),
                // acceptTermsTextRow(),
                SizedBox(height: _height/35,),
                button(),
                // signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/7 : _height/6.5),
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
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: chooseFile,
            child: Container(
              height: _height / 6,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(_image.path)) ,
                  ) ,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.0,
                      color: Colors.black26,
                      offset: Offset(1.0, 10.0),
                      blurRadius: 20.0),
                ],
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                  onTap: (){
                    chooseFile();
                  },
                  child: Center(
                    child: _image.path == ""
                      ? Icon(Icons.add_a_photo, size: _large? 40: (_medium? 33: 31),color: Colors.orange[200],)
                      : SizedBox.shrink(),
                  ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left:_width/ 12.0,
          right: _width / 12.0,
          top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height/ 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      textEditingController: _nameController,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Nh???p t??n c???a b???n",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: _emailController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Nh???p ?????a ch??? email",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      textEditingController: _passController,
      obscureText: true,
      icon: Icons.lock,
      hint: "Nh???p m???t kh???u",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      textEditingController: _passConfirmController,
      obscureText: true,
      icon: Icons.lock,
      hint: "X??c nh???n l???i m???t kh???u",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "T??i ?????ng ?? v???i ??i???u kho???n c???a ???ng d???ng",
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: _large? 15: (_medium? 13: 11)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed:onSignUpClick,
        // checkBoxValue ?
        // () => onSignUpClick() :
        // null,
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
       height: _height / 15,
        width: MediaQuery.of(context).size.width - 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
            // checkBoxValue
            //     ? <Color>[Colors.orange[200], Colors.pinkAccent]
            //       : <Color>[Colors.orange[100], Colors.pinkAccent[100]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('????NG K??', style: GoogleFonts.quicksand(fontSize: _large? 20: (_medium? 18: 15), fontWeight: FontWeight.bold),),
      ),
    );
  }


  void onSignUpClick() {
    setState(() {
      String name = _nameController.text;
      String email = _emailController.text;
      String pass = _passController.text;
      String passConfirm = _passConfirmController.text;


      if (name=="" || email=="" || pass==null || passConfirm==null){
        Toast.show("Vui l??ng nh???p ?????y ????? th??ng tin", context, duration: 3, gravity: Toast.BOTTOM);
      }else if(pass != passConfirm){
        Toast.show("Nh???p l???i m???t kh???u kh??ng kh???p", context, duration: 3, gravity: Toast.BOTTOM);
      }else {
        ProgressLoading().showLoading(context);
        createUser();
      }
    });
  }
}
