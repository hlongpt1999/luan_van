import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/resources/button_circle_max.dart';
import 'package:luan_van/screens/home/HomeScreen.dart';
import 'package:toast/toast.dart';

import '../../main.dart';

class ChangeInfoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChangeInfoScreenState();
}

class ChangeInfoScreenState extends State<ChangeInfoScreen>{
  PickedFile _image = PickedFile("");
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController =TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  String avatarURL = "";
  Future<void> loadAvatar() async {
    var ref = firebase_storage.FirebaseStorage.instance
        .ref(CurrentUser.currentUser.avatar);
    String avatar = await ref.getDownloadURL();
    setState(() {
      avatarURL = avatar;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAvatar();
    _nameController.text = CurrentUser.currentUser.name;
    _emailController.text = CurrentUser.currentUser.email;
    _addressController.text = CurrentUser.currentUser.address ?? "";
    _phoneController.text = CurrentUser.currentUser.phone ?? "";
  }

  Future chooseFile() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void onLuuClick() {
    setState(() {
      String name = _nameController.text;
      String email = _emailController.text;
      String address = _addressController.text;
      String phone = _phoneController.text;


      if (name=="" || email==""){
        showDialog(
          context: context,
          builder: (_context)=> AlertDialog(
            title: Text("L???i", style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
            ),),
            content: Text("Vui l??ng nh???p ????? t??n v?? email", style: GoogleFonts.quicksand(),),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("???? hi???u", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      }else {
        ProgressLoading().showLoading(context);
        updateUser();
      }
    });
  }

  Future updateUser() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    String name = _nameController.text;
    String email = _emailController.text;
    String address = _addressController.text;
    String phone = _phoneController.text;

    if(_image.path != "") {
      String avatar = 'avatars/' + CurrentUser.currentUser.id + '.png';
      uploadFile(avatar);
    }
    await firebaseFirestore.collection('users').doc(CurrentUser.currentUser.id).update(
        {
          'name': name ?? CurrentUser.currentUser.name,
          'email': email ?? CurrentUser.currentUser.email,
          'address': address ?? CurrentUser.currentUser.address,
          'phone': phone ?? CurrentUser.currentUser.phone,
        }
    ).whenComplete((){
      if(name != "" && name != null)
      CurrentUser.currentUser.name = name;

      if(email != "" && email != null)
      CurrentUser.currentUser.email = email ?? "";
      CurrentUser.currentUser.address = address ?? "";
      CurrentUser.currentUser.phone = phone ?? "";
    });
    Toast.show('???? c???p nh???t th??nh c??ng t??i kho???n: ' + _nameController.text, context);
    ProgressLoading().hideLoading(context);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()),(Route<dynamic> route) => false);
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_rounded, color: Colors.black,)),
          backgroundColor: Colors.white,
          title: Center(child: Text("Thay ?????i th??ng tin", style: GoogleFonts.quicksand(color: Colors.black, fontWeight: FontWeight.bold),)),
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
              children: [
                Container(
                  height: 130,
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: chooseFile,
                    child: Container(
                      height: 128,
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
                              ? CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 130,
                                  child: CircleAvatar(
                                    backgroundImage: avatarURL != ""
                                        ? NetworkImage(avatarURL)
                                        : AssetImage('assets/home.jpeg'),
                                    radius: 127,
                                  ),
                                 )
                              : SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nh???p t??n c???a b???n",
                    labelText: "Nh???p t??n c???a b???n",
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
                      Icons.drive_file_rename_outline,
                      color: Colors.white,),
                  ),
                  style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Nh???p email c???a b???n",
                    labelText: "Nh???p email c???a b???n",
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
                      Icons.email_outlined,
                      color: Colors.white,),
                  ),
                  style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Nh???p ?????a ch??? c???a b???n",
                    labelText: "Nh???p ?????a ch??? c???a b???n",
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
                      Icons.place_outlined,
                      color: Colors.white,),
                  ),
                  style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "Nh???p s??? ??i???n tho???i",
                    labelText: "Nh???p s??? ??i???n tho???i",
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
                      Icons.contact_phone_outlined,
                      color: Colors.white,),
                  ),
                  style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white,),
                ),

                SizedBox(height: 20,),

                InkWell(
                  onTap: onLuuClick,
                  child: buttonCircleMax(context, "L??u", color1: Colors.deepOrange, color2: Colors.orangeAccent),
                ),

              ],
            ),
          ),
        )
    );
  }
}