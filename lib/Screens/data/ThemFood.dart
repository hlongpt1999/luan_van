import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/resources/button_radius_medium.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ThemFood extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ThemFoodState();
}

List<String> listLoaiThucPham = [
  "Thịt cá",
  "Trứng sữa",
  "Trái cây",
  "Ngũ cốc",
  "Rau củ"
];

class ThemFoodState extends State<ThemFood>{
  TextEditingController _nameC = TextEditingController();
  TextEditingController _caloC = TextEditingController();
  //Prio... 1-50calo = 1 ,
  //51-100 =2,
  //101-150=3.......
  String loaiThucPham = listLoaiThucPham[0];

  int ghiChuLength = 1;
  List<TextEditingController> ghiChuController = [
    TextEditingController(),TextEditingController(),TextEditingController(),
    TextEditingController(),TextEditingController(),TextEditingController(),
    TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()
  ];

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
    var type = loaiThucPham;
    List<String> vitamin = [];
    var calo = double.parse(_caloC.text);
    var priority = (calo/50 + 1).round();

    for (int i=0; i<ghiChuLength ;i++){
      vitamin.add(ghiChuController[i].text);
    }

    String foodImage = "";
    if(_image.path != "") {
      foodImage = 'foods/' + name + '.png';
      uploadFile(foodImage);
    }

    FoodModel foodModel = FoodModel(idFood: id, name: name, type: type, vitamin: vitamin, calo100g: calo, priority: priority, foodImage: foodImage);

    //Cách thêm này hơi rườm rà
    // await firebaseFirestore.collection('Foods').doc(type).collection(prio.toString()).doc(name).set(foodModel.toMap());
    await firebaseFirestore.collection(Const.CSDL_FOODS).doc(name).set(foodModel.toMap());
    Toast.show('Đã thêm thực phẩm : ' + name, context);
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
        title: Center(child: Text("Thêm thực phẩm", style: GoogleFonts.quicksand(color: HexColor("392950"), fontWeight: FontWeight.bold),)),
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
              Field(_nameC, "Tên thực phẩm", TextInputType.text, Icons.drive_file_rename_outline),
              SizedBox(height: 20,),

              Row(
                children: [
                  Center(
                    child: Text(
                      "Loại thực phẩm: ",
                      style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  SizedBox(width: 20,),

                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.transparent,
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 20 ),
                      value: loaiThucPham,
                      onChanged: (String data1) {
                        setState(() {
                          loaiThucPham = data1;
                        });
                      },
                      items: listLoaiThucPham.map<DropdownMenuItem<String>>((String value1) {
                        return DropdownMenuItem<String>(
                          value: value1,
                          child: Text(value1, style: GoogleFonts.quicksand(fontSize: 20),),
                        );
                      }).toList(),
                    ),
                  ),


                ],
              ),
              SizedBox(height: 20,),

              Field(_caloC, "Số calo trên 100g",TextInputType.number, Icons.confirmation_number),
              SizedBox(height: 20,),

              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ghi chú: ",
                      style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20,),

                  ghiChuLength>0
                  ? GestureDetector(
                    onTap: (){
                        setState(() {
                          ghiChuLength -=1;
                        });
                    },
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ) : SizedBox.shrink(),
                  ghiChuLength>0 ? SizedBox(width: 20,) : SizedBox.shrink(),

                  ghiChuLength<10
                  ? GestureDetector(
                    onTap: (){
                      setState(() {
                        ghiChuLength += 1;
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ) : SizedBox.shrink(),
                ],
              ),

              SizedBox(height: 10,),

              for(int i=0; i<ghiChuLength;i++)
              Container(
                height: 50,
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        controller: ghiChuController[i],
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Nhập ghi chú",
                          hintStyle: GoogleFonts.quicksand(
                            color: Colors.grey,
                          ),
                        ),
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    // TextField(),


                  ],
                ),
              ),

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
                        style: GoogleFonts.quicksand(
                          color: HexColor("392950"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
    if (_nameC.text.trim() == "" || _caloC.text.trim() =="" || _image.path =="" )
      return true;
    for (int i=0;i<ghiChuLength;i++){
      if(ghiChuController[i].text.toString() == "")
        return true;
    }
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
          _icon,
          color: Colors.white,),
      ),
      style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white),
    );
  }
}