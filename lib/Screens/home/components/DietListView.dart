import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/MealsListData.dart';
import 'package:luan_van/resources/AppTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class DietListView extends StatefulWidget{
  final int keyHomNao;

  const DietListView ({ Key key, this.keyHomNao }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DietListViewState();
  }
}

class DietListViewState extends State<DietListView>{
  List<FoodModel> listData = [];
  FoodModel foodDetail = FoodModel();
  Future getData() async{
    listData.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    DateTime todayHomNao = DateTime(now.year, now.month, now.day + widget.keyHomNao, 12, 0, 0, 0, 0);
    String today = DateFormat("dd/M/yyyy").format(todayHomNao);
    List<String> listPrefData = pref.getStringList(today);
    for (var i=0;i<listPrefData.length;i++) {
      var name = listPrefData[i];
      List<String> listPrefData2 = pref.getStringList(name);
      FoodModel foodModel = FoodModel(
          name: name,
          calo100g: double.parse(listPrefData2[0]),
          quantity: int.parse(listPrefData2[1]),
          foodImage: listPrefData2[2],
          type: listPrefData2[3]
      );
      listData.add(foodModel);
    }
    if(widget.keyHomNao == 0)
      CurrentUser.listFood = listData;
  }

  Future getFoodDetail(String foodName, String imageFood) async{
    await FirebaseFirestore.instance.collection(Const.CSDL_FOODS).doc(foodName).get().then(
      (value) {
        var data = value.data() as Map<String, dynamic>;
        foodDetail = FoodModel.fromJson(data);
    }
    ).whenComplete(
            (){
              ProgressLoading().hideLoading(context);
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              context: context,
              builder: (context){
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                    height:  modalBottomHeight, // C??? ?????nh 400
                    // height:  modalBottomHeight + (foodDetail.vitamin.length ?? 0 ) * 40,// M???i h??ng l??u ?? 300 + 40 m???i h??ng
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 15,),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Image.network(imageFood, width: 100, height: 100,)),
                          Container (
                            height: 50,
                            child: Center(
                              child: Wrap(
                                children: [
                                  Text(
                                    foodDetail.name,
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container (
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Cung c???p:" ,
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),

                                Text(
                                  foodDetail.calo100g.round().toString()+ "calo/100g" ,
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      color: foodDetail.priority==1 ? Colors.green[800]
                                          : (foodDetail.priority==2 ? Colors.greenAccent
                                          : (foodDetail.priority==3 ? Colors.yellow
                                          : (foodDetail.priority==4 ? Colors.orangeAccent
                                          : (foodDetail.priority==5 ? Colors.red : Colors.blueGrey)))),
                                      fontSize: 20
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container (
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "Nh??m:" ,
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Chip(
                                    backgroundColor: foodDetail.type=="Th???t c??" ? Colors.red
                                        : (foodDetail.type=="Tr???ng s???a" ? Colors.yellow
                                        : (foodDetail.type=="Tr??i c??y" ? Colors.orangeAccent
                                        : (foodDetail.type=="Rau c???" ? Colors.green
                                        : (foodDetail.type=="Tinh b???t" ? Colors.blueGrey : Colors.purple)))),
                                    label: Text(
                                      foodDetail.type,
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),

                          Container (
                            height: 50,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Th??ng tin th??m:" ,
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          ),

                          if (foodDetail.vitamin.length != null)
                            for(int i=0; i<foodDetail.vitamin.length;i++)
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: "- "+foodDetail.vitamin[i],
                                    style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontSize: 19
                                    ),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),

                          SizedBox(height: 15,),

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  double modalBottomHeight = 450;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      width: double.infinity,
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          return ListView.builder(
            padding: const EdgeInsets.only(
                top: 0, bottom: 0, right: 16, left: 16),
            itemCount: listData.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final int count =
              listData.length > 10 ? 10 : listData.length;
              return GestureDetector(
                onTap: (){
                  ProgressLoading().showLoading(context);
                  getFoodDetail(listData[index].name, listData[index].foodImage);
                },
                child: MealsView(
                  foodModel: listData[index],
                ),
              );
            },
          );
        }
      ),
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView({Key key, this.foodModel}) : super(key: key);

  final FoodModel foodModel;

  @override
  Widget build(BuildContext context) {
        return SizedBox(
          width: 140,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, left: 8, right: 8, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.white
                              .withOpacity(0.6),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0),
                    ],
                    gradient: LinearGradient(
                      colors: [
                    foodModel.type=="Th???t c??" ? Colors.red
                        : (foodModel.type=="Tr???ng s???a" ? Colors.yellow
                        : (foodModel.type=="Tr??i c??y" ? Colors.orangeAccent
                        : (foodModel.type=="Rau c???" ? Colors.green
                        : (foodModel.type=="Tinh b???t" ? Colors.blueGrey : Colors.purple)))),
                        foodModel.type=="Th???t c??" ? Colors.red[200]
                            : (foodModel.type=="Tr???ng s???a" ? Colors.yellow[200]
                            : (foodModel.type=="Tr??i c??y" ? Colors.orangeAccent[200]
                            : (foodModel.type=="Rau c???" ? Colors.green[200]
                            : (foodModel.type=="Tinh b???t" ? Colors.blueGrey[200] : Colors.purple[200])))),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(54.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 54, left: 16, right: 16, bottom: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            foodModel.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  foodModel.quantity>=1000 ? (foodModel.quantity/10).toString() + "kg" : (foodModel.quantity).toString() + "g",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    letterSpacing: 0.2,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // mealsListData?.kacl != 0 ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              (foodModel.quantity/100 * foodModel.calo100g).round().toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0.2,
                                color: AppTheme.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, bottom: 3),
                              child: Text(
                                'Calo',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyWhite.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(foodModel.foodImage),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        );
  }
}
