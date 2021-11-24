import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/MovementModel.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ThemBaiTapScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ThemBaiTapScreenState();
}

List<String> listNhomCo = [
  "Đầu, cổ",
  "Thân trên",
  "Tay",
  "Chân",
  "Toàn thân"
];

List<String> listDonVi = [
  "lần", "mét", "phút",
];

class ThemBaiTapScreenState extends State<ThemBaiTapScreen>{
  TextEditingController _nameC = TextEditingController();
  TextEditingController _caloC = TextEditingController();
  TextEditingController _detailC = TextEditingController();
  TextEditingController _linkC = TextEditingController();
  //Prio... 1-50calo = 1 ,
  //51-100 =2,
  //101-150=3.......
  String nhomCo = listNhomCo[0];
  String donVi = listDonVi[0];

  PickedFile _image = PickedFile("");
  Future chooseFile() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery) ?? "";
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

  Future<void> Gui(BuildContext mContext) async{
    ProgressLoading().showLoading(mContext);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var id = _nameC.text;
    var name = _nameC.text;
    var type = nhomCo;
    var detail = _detailC.text;
    var link = _linkC.text;
    var calo = double.parse(_caloC.text);
    // var priority = (calo/50 + 1).round();//TODO MOVEMENT CHƯA TÍNH ĐƯỢC NHư nào là nhiều.

    String imageDetail = "";
    if(_image.path != "") {
      imageDetail = 'dongtac/' + name + '.png';
      uploadFile(imageDetail);
    }

    MovementModel movementModel =MovementModel(
      idMovement: id,
      name: name,
      type: type,
      detail: detail,
      link: link,
      caloLost100g: calo,
      imageDetail: imageDetail,
      priority: 0,
      donvi: donVi,
    );

    //Cách thêm này hơi rườm rà
    await firebaseFirestore.collection(Const.CSDL_DONGTAC).doc(name).set(movementModel.toMap());
    Toast.show('Đã thêm động tác : ' + name, context);
    ProgressLoading().hideLoading(mContext);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded, color: HexColor("392950"),)),
        backgroundColor: Colors.white,
        title: Center(child: Text("Thêm động tác", style: TextStyle(color: HexColor("392950"), fontWeight: FontWeight.bold),)),
        actions: [
          SizedBox(width: 50,),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: HexColor("392950"),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: MediaQuery.of(context).size.width/2.5,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: chooseFile,
                  child: Container(
                    height: MediaQuery.of(context).size.width/3,
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
                            ? Icon(Icons.add_a_photo, size: 40,color: Colors.orange[200],)
                            : SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Field(_nameC, "Tên động tác", TextInputType.text, Icons.drive_file_rename_outline),
              SizedBox(height: 20,),

              Row(
                children: [
                  Center(
                    child: Text(
                      "Nhóm cơ ở: ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  SizedBox(width: 20,),

                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.transparent,
                      style: TextStyle(color: Colors.white, fontSize: 20 ),
                      value: nhomCo,
                      onChanged: (String data1) {
                        setState(() {
                          nhomCo = data1;
                        });
                      },
                      items: listNhomCo.map<DropdownMenuItem<String>>((String value1) {
                        return DropdownMenuItem<String>(
                          value: value1,
                          child: Text(value1, style: TextStyle(fontSize: 20),),
                        );
                      }).toList(),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 20,),

              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*2/3,
                      child: Field(_caloC, "Tiêu hao calo/1 đơn vị",TextInputType.number, Icons.confirmation_number)),

                  SizedBox(width: 10,),

                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.transparent,
                      style: TextStyle(color: Colors.white, fontSize: 20 ),
                      value: donVi,
                      onChanged: (String data1) {
                        setState(() {
                          donVi = data1;
                        });
                      },
                      items: listDonVi.map<DropdownMenuItem<String>>((String value1) {
                        return DropdownMenuItem<String>(
                          value: value1,
                          child: Text(value1, style: TextStyle(fontSize: 20),),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),

              Field(_detailC, "Chi tiết thực hiện",TextInputType.text, Icons.list),
              SizedBox(height: 20,),

              Field(_linkC, "Liên kết hướng dẫn",TextInputType.text, Icons.link),
              SizedBox(height: 20,),

              GestureDetector(
                onTap: (){
                  if(!isNull())
                    Gui(context);
                  else
                    Toast.show("Nhập đầy đủ thông và ảnh", context);
                },
                child: Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Thêm",
                      style: TextStyle(
                        color: HexColor("392950"),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  bool isNull(){
    if (_nameC.text.trim() == "" || _caloC.text.trim() =="" || _image.path ==""
    || _detailC.text.trim() == "")
      return true;
    return false;
  }

  Widget Field(TextEditingController _controller, String _name, TextInputType _type, IconData _icon){
    return TextFormField(
      controller: _controller,
      keyboardType: _type,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: _name,
        labelText: _name,
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
          _icon,
          color: Colors.white,),
      ),
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}