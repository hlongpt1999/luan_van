import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/components/progressLoading.dart';
import 'package:luan_van/resources/styles.dart';
import 'package:luan_van/screens/login/Login.dart';

class SearchScheduleScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SearchScheduleScreenState();
}

class SearchScheduleScreenState extends State<SearchScheduleScreen>{
  List<String> tenThucDon = [];
  List<String> tenLuyenTap = [];
  List<String> ketQuaDaChon = ["",""];
  List<String> tenThucDonKQ = [];
  List<String> tenLuyenTapKQ = [];

  TextEditingController keyController = TextEditingController();

  Future<void> getAllBaiTap() async {
    ProgressLoading().showLoading(context);
    tenThucDon.clear();
    await FirebaseFirestore.instance.collection(Const.CSDL_SCHEDULE).get().then((value){
      value.docs.forEach((element) {
        var data = element.data() as Map<String, dynamic>;
        if(data["name"]!=Const.MOI_DOI_TUONG)
          tenThucDon.add(data["name"]);
      });
    });

    tenLuyenTap.clear();
    await FirebaseFirestore.instance.collection(Const.CSDL_SCHEDULE_LUYENTAP).get().then((value){
      value.docs.forEach((element) {
        var data = element.data() as Map<String, dynamic>;
        if(data["name"]!=Const.MOI_DOI_TUONG)
          tenLuyenTap.add(data["name"]);
      });
    }).whenComplete((){
      ProgressLoading().hideLoading(context);
    });
  }

  Future<void> ketQuaTimKiem() async{
    var key = keyController.text.toString().toLowerCase();
    if(ketQuaDaChon[0]!="" && ketQuaDaChon[1]!=""){
      showDialog(
        context: context,
        builder: (_context) =>
            AlertDialog(
              title: Text("Thông báo",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
              content: Text(
                "Bạn đã chọn đủ bài tập, vui lòng xóa nếu muốn chọn bài khác",
                style: GoogleFonts.quicksand(),),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Đã hiểu",
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold),),
                ),
              ],
            ),
      );
      return;
    }
    setState(() {
      tenThucDonKQ = [];
      tenLuyenTapKQ = [];
    });
    if(key.trim() != "" && key.isNotEmpty) {
      ProgressLoading().showLoading(context);
      if(ketQuaDaChon[0]=="")
      for (int i = 0; i < tenThucDon.length; i++){
        if (tenThucDon[i].toLowerCase().contains(key)){
          setState(() {
            tenThucDonKQ.add(tenThucDon[i]);
          });
        }
      }
      if(ketQuaDaChon[1]=="")
      for (int j = 0; j < tenLuyenTap.length; j++){
        if (tenLuyenTap[j].toLowerCase().contains(key)){
          setState(() {
            tenLuyenTapKQ.add(tenLuyenTap[j]);
          });
        }
      }
      ProgressLoading().hideLoading(context);
    }
    if(key.trim()!="" && tenLuyenTapKQ.isEmpty && tenThucDonKQ.isEmpty){
      showDialog(
        context: context,
        builder: (_context) =>
            AlertDialog(
              title: Text("Thông báo",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
              content: RichText(
                text: TextSpan(
                  text: "Không có kết quả với từ khóa: \n",
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan (
                      text: "'"+key+"'",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Đã hiểu",
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold),),
                ),
              ],
            ),
      );
      return;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      this.getAllBaiTap();
    });
  }

  double heightTimKiem = 200;
  double height1 = 0, height2 = 0, height3=00;

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
          title: Center(child: Text("Tìm lịch theo tên", style: GoogleFonts.quicksand(color: Colors.black, fontWeight: FontWeight.bold),)),
          actions: [
            SizedBox(width: 50,),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, right: 20, left: 20),
          color: MyColor.colorBackgroundTab,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: TextFormField(
                  controller: keyController,
                  decoration: InputDecoration(
                    hintText: "Nhập tên lịch muốn tìm",
                    hintStyle: GoogleFonts.quicksand(),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: ketQuaTimKiem,
                      icon: Icon(
                        Icons.search_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  style: GoogleFonts.quicksand(fontSize: 20, color: Colors.black,),
                ),
              ),

              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                child: Text(
                  "Đã chọn:",
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),),
              ),

              ketQuaDaChon[0] == ""
                  ? SizedBox.shrink()
                  : Container(
                height: 60,
                child: Column(
                  children: [
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 115,
                            child: Text(
                              "Thực đơn: "+ ketQuaDaChon[0],
                              style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                height1 = 0;
                                height3 = 0;
                                ketQuaDaChon[0] = "";
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 60,
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6,),
                  ],
                ),
              ),

              ketQuaDaChon[1] == ""
                  ? SizedBox.shrink()
                  : Container(
                height: 60,
                child: Column(
                  children: [
                    Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 115,
                            child: Text(
                              "Luyện tập: "+ ketQuaDaChon[1],
                              style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                height2 = 0;
                                height3 = 0;
                                ketQuaDaChon[1] = "";
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 60,
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6,),
                  ],
                ),
              ),

              (ketQuaDaChon[0] == "" || ketQuaDaChon[1] == "")
                  ? SizedBox.shrink()
                  : Container(
                height: 60,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Const.KEY_FROM = Const.FROM_BMI;
                        CurrentUser.goiCalo=2000;
                        CurrentUser.goiCaloDC=2000;
                        CurrentUser.tenGoi1 = ketQuaDaChon[0];
                        CurrentUser.tenGoi2 = ketQuaDaChon[1];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                      },
                      child: Container(
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.create_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "TẠO LỊCH",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 6,),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                child: Text(
                  "Kết quả tìm kiếm:",
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),),
              ),

              Container(
                height: MediaQuery.of(context).size.height - 250 - height2 - height1 - height3,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int a=0 ; a<tenThucDonKQ.length; a++)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  ketQuaDaChon[0] = tenThucDonKQ[a];
                                  tenThucDonKQ = [];
                                  height1 = 60;
                                  if(ketQuaDaChon[1] != "")
                                    height3 = 60;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Text(
                                  "Thực đơn: "+tenThucDonKQ[a],
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6,),
                          ],
                        ),

                      for (int b=0 ; b<tenLuyenTapKQ.length; b++)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  ketQuaDaChon[1] = tenLuyenTapKQ[b];
                                  tenLuyenTapKQ = [];
                                  height2 = 60;
                                  if(ketQuaDaChon[0] != "")
                                    height3 = 60;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Text(
                                  "Luyện tập: "+tenLuyenTapKQ[b],
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6,),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}