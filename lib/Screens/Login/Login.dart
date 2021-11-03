import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/screens/schedule/ScheduleDetailScreen.dart';

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp> {
  Future<void> getFoods() async{
    // QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("test").get().then(
            (value){
          value.docs.forEach((element) {
            var data = element.data() as Map<String, dynamic>;
            FoodModel foodModel = FoodModel(
              name: data['name'],
              type: data["type"],
              calo100g: data["calo100g"],
              priority: data["priority"],
              foodImage: data["foodImage"],
              quantity: data["quantity"],
            );
            CurrentUser.listFood.add(foodModel);
            CurrentUser.listFoodString.add(foodModel.name);
          });

        }
    ).whenComplete((){
      ProgressLoading().hideLoading(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleDetailScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            ProgressLoading().showLoading(context);
            getFoods();
          },
          child: Container(
            color: Colors.blue,
            height: 300,
            width: 300,
            child: Text("Nút"),
          ),
        ),
      ),
    );
  }
}