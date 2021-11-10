import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/MealsListData.dart';
import 'package:luan_van/resources/AppTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietListView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    getData();
    return DietListViewState();
  }
}

List<FoodModel> listData = [];
Future getData() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> listPrefData = pref.getStringList("1");
  for (var i=0;i<listPrefData.length;i++) {
    var name = listPrefData[i];
    List<String> listPrefData2 = pref.getStringList(name);
    FoodModel foodModel = FoodModel(name: name, calo100g: double.parse(listPrefData2[0]), quantity: int.parse(listPrefData2[1]));
    listData.add(foodModel);
  }
}

class DietListViewState extends State<DietListView>{
  // List<MealsListData> mealsListData = MealsListData.tabIconsList;
  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.only(
            top: 0, bottom: 0, right: 16, left: 16),
        itemCount: listData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final int count =
          listData.length > 10 ? 10 : listData.length;

          return MealsView(
            foodModel: listData[index],
          );
        },
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
                          color: Colors.orange
                              .withOpacity(0.6),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.green,
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
                        Text(
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
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  foodModel.quantity>=10 ? (foodModel.quantity/10).toString() + "kg" : (foodModel.quantity * 100).toString() + "g",
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
                                'kcal',
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
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyWhite.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 8,
                child: Container(
                  width: 80,
                  height: 80,
                  child: Image.asset("assets/fitness_app/breakfast.png", width: 80, height: 80,),
                ),
              )
            ],
          ),
        );
  }
}
