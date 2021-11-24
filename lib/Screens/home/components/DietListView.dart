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
  }
//TODO gắn food name(Đẻ lên firestore tìm kiếm) và imageFood(link) vào
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
                    padding: EdgeInsets.all(20),
                    height:  modalBottomHeight + (foodDetail.vitamin.length ?? 0 ) * 40,//TODO:300+ Mỗi hàng lưu ý
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
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
                                  "Cung cấp:" ,
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),

                              Text(
                                foodDetail.calo100g.round().toString()+ "calo/100g" , //TODO: Thêm calo
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
                                    "Nhóm:" ,//todo: Thêm nhóm
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Chip(
                                  backgroundColor: foodDetail.type=="Thịt cá" ? Colors.red
                                      : (foodDetail.type=="Trứng sữa" ? Colors.yellow
                                      : (foodDetail.type=="Trái cây" ? Colors.orangeAccent
                                      : (foodDetail.type=="Rau củ" ? Colors.green
                                      : (foodDetail.type=="Tinh bột" ? Colors.blueGrey : Colors.purple)))),
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
                              "Thông tin thêm:" ,
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
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      child: Text(
                                        "- "+foodDetail.vitamin[i],
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontSize: 19
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  double modalBottomHeight = 360;//todo: 300+ Mỗi hàng lưu ý x 50.

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
          width: 130,
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
                    foodModel.type=="Thịt cá" ? Colors.red
                        : (foodModel.type=="Trứng sữa" ? Colors.yellow
                        : (foodModel.type=="Trái cây" ? Colors.orangeAccent
                        : (foodModel.type=="Rau củ" ? Colors.green
                        : (foodModel.type=="Tinh bột" ? Colors.blueGrey : Colors.purple)))),
                        foodModel.type=="Thịt cá" ? Colors.red[200]
                            : (foodModel.type=="Trứng sữa" ? Colors.yellow[200]
                            : (foodModel.type=="Trái cây" ? Colors.orangeAccent[200]
                            : (foodModel.type=="Rau củ" ? Colors.green[200]
                            : (foodModel.type=="Tinh bột" ? Colors.blueGrey[200] : Colors.purple[200])))),
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
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
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
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
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
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
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
                                style: TextStyle(
                                  fontFamily:
                                  AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                          //   : Container(
                          // decoration: BoxDecoration(
                          //   color: AppTheme.nearlyWhite,
                          //   shape: BoxShape.circle,
                          //   boxShadow: <BoxShadow>[
                          //     BoxShadow(
                          //         color: AppTheme.nearlyBlack
                          //             .withOpacity(0.4),
                          //         offset: Offset(8.0, 8.0),
                          //         blurRadius: 8.0),
                          //   ],
                          // ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: Icon(
                          //     Icons.add,
                          //     color: HexColor(mealsListData.endColor),
                          //     size: 24,
                          //   ),
                          // ),
                        // ),
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
                  // child: Image.network(foodModel.foodImage, width: 80, height: 80,),
                ),
              )
            ],
          ),
        );
  }
}
