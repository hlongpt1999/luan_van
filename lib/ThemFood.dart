import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/resources/button_radius_medium.dart';
import 'package:toast/toast.dart';

class ThemFood extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ThemFoodState();
}

class ThemFoodState extends State<ThemFood>{
  TextEditingController _nameC = TextEditingController();
  TextEditingController _typeC = TextEditingController();
  TextEditingController _caloC = TextEditingController();
  TextEditingController _priorityC =TextEditingController();
  //Prio... 1-50calo = 1 ,
  //51-100 =2,
  //101-150=3.......

  Future<void> Gui(BuildContext mContext) async{
    ProgressLoading().showLoading(mContext);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var id = _nameC.text;
    var name = _nameC.text;
    var type = _typeC.text;
    List<String> vitamin = [];
    var calo = double.parse(_caloC.text);
    var prio = int.parse(_priorityC.text);
    FoodModel foodModel = FoodModel(idFood: id, name: name, type: type, vitamin: vitamin, calo100g: calo, priority: prio);

    //Cách thêm này hơi rườm rà
    // await firebaseFirestore.collection('Foods').doc(type).collection(prio.toString()).doc(name).set(foodModel.toMap());
    await firebaseFirestore.collection('test').doc(name).set(foodModel.toMap());
    Toast.show('Đã thêm thành công : ' + name, context);
    ProgressLoading().hideLoading(mContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Field(_nameC, "Tên", TextInputType.text),
            SizedBox(height: 20,),
            Field(_typeC, "Loại thực phẩm thịt cá trứng sữa",TextInputType.text),
            SizedBox(height: 20,),
            Field(_caloC, "Số calo trên 100g",TextInputType.number),
            SizedBox(height: 20,),
            Field(_priorityC, "Đo mức đố calo,tự tính tay",TextInputType.number),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Gui(context);
              },
                child: buttonRadiusMedium("Gửi", Colors.pink),
            ),
          ],
        ),
      ),
    );
  }

  Widget Field(TextEditingController _controller, String _name, TextInputType _type){
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
          Icons.person_outline,
          color: Colors.white,),
      ),
      style: TextStyle(fontSize: 20),
    );
  }
}