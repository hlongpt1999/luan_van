import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/model/FoodModel.dart';
import 'package:luan_van/model/MealsListData.dart';
import 'package:luan_van/model/MovementModel.dart';
import 'package:luan_van/resources/AppTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:marquee/marquee.dart';

class LuyenTapListView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LuyenTapListViewState();
  }
}

class LuyenTapListViewState extends State<LuyenTapListView>{

  List<FoodModel> listData = [];
  Future getData() async{
    listData.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> listPrefData = pref.getStringList("1");
    for (var i=0;i<listPrefData.length;i++) {
      var name = listPrefData[i];
      List<String> listPrefData2 = pref.getStringList(name);
      print("LENGTH--" + listPrefData.length.toString());
      FoodModel foodModel = FoodModel(name: listPrefData2[2], calo100g: double.parse(listPrefData2[0]), quantity: int.parse(listPrefData2[1]));
      listData.add(foodModel);
    }
  }

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  YoutubePlayerController _controller;
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'ruWVlqG1P6Q',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MovementModel detailDongTac = MovementModel(name: "Test nhaaaaaa", caloLost100g: 12345, type: "Đầu", detail: "AAAAA");
  
  Future getDongTac()async{
    await FirebaseFirestore.instance.collection(Const.CSDL_TEST).doc("Long").get().then(
            (value) {
          var data = value.data() as Map<String, dynamic>;
          // foodDetail = FoodModel.fromJson(data);
        }
    ).whenComplete(
            (){
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
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              onReady: (){
                                _controller.addListener(listener);
                              },
                            ),
                          ),
                        ),

                        Container (
                          height: 50,
                          child: Center(
                            child: Wrap(
                              children: [
                                Text(
                                  detailDongTac.name, //TODO;Name
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
                                  "Tiêu hao:" ,
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),

                              Text(
                                detailDongTac.caloLost100g.round().toString()+ "calo/1 động tác" , //TODO: Thêm calo
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    // color: listData[index].priority==1 ? Colors.green
                                    //     : (listData[index].priority==2 ? Colors.greenAccent
                                    //     : (listData[index].priority==3 ? Colors.yellow
                                    //     : (listData[index].priority==4 ? Colors.orangeAccent
                                    //     : (listData[index].priority==5 ? Colors.red : Colors.blueGrey)))),
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
                                    "Nhóm cơ:" ,//todo: Thêm nhóm
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Chip(
                                  // backgroundColor: listData[index].type=="Thịt, cá" ? Colors.red
                                  //     : (listData[index].type=="Trứng, sữa" ? Colors.yellow
                                  //     : (listData[index].type=="Trái cây" ? Colors.orangeAccent
                                  //     : (listData[index].type=="Rau củ" ? Colors.green
                                  //     : (listData[index].type=="Tinh bột" ? Colors.blueGrey : Colors.purple)))),
                                  label: Text(
                                    detailDongTac.type,
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
                              "Cách thực hiện:" ,//todo: Thêm danh sách lưu ý
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.topLeft,
                          height: 50,
                          child: Marquee(
                            text: detailDongTac.detail+"AAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAA AAAAAAAAAAAA",
                            style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontSize: 19
                            ),
                            startPadding: 30,
                            blankSpace: 100,
                            startAfter: Duration(seconds: 3),
                            decelerationDuration: Duration(seconds: 1),
                            decelerationCurve: Curves.decelerate,
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

                print("LISTDATA--"+listData.length.toString());

                return GestureDetector(
                  onTap: (){
                    getDongTac();
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
