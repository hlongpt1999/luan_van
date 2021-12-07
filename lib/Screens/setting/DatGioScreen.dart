import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatGioScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DatGioScreenState();
}

Future<void> luuLich() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setStringList(Const.KEY_DAT_GIO, [
    CurrentUser.lichNhacNho.toString(),
    CurrentUser.nhacNhoGIO.toString(),
    CurrentUser.nhacNhoPHUT.toString(),
    CurrentUser.lichDaLam.toString(),
    CurrentUser.daLamGIO.toString(),
    CurrentUser.daLamPHUT.toString(),
  ]);
}

class DatGioScreenState extends State<DatGioScreen>{
  TimeOfDay _time1 = TimeOfDay(hour: CurrentUser.nhacNhoGIO, minute: CurrentUser.nhacNhoPHUT);
  TimeOfDay _time2 = TimeOfDay(hour: CurrentUser.daLamGIO, minute: CurrentUser.daLamPHUT);

  void selectNhoNhoTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time1,
    );
    if (newTime != null) {
      setState(() {
        _time1 = newTime;
        CurrentUser.nhacNhoGIO = newTime.hour;
        CurrentUser.nhacNhoPHUT = newTime.minute;
      });
    }
  }

  void selectCuoiNgayTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time2,
    );
    if (newTime != null) {
      setState(() {
        _time2 = newTime;
        CurrentUser.daLamGIO = newTime.hour;
        CurrentUser.daLamPHUT = newTime.minute;
        luuLich();
      });
    }
  }

  Future<void> moLich() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> list = pref.getStringList(Const.KEY_DAT_GIO);
    setState(() {
      CurrentUser.lichNhacNho = list[0] == "true" ? true : false;
      CurrentUser.nhacNhoGIO = int.parse(list[1]);
      CurrentUser.nhacNhoPHUT= int.parse(list[2]);
      CurrentUser.lichDaLam = list[3] == "true" ? true : false;
      CurrentUser.daLamGIO = int.parse(list[4]);
      CurrentUser.daLamPHUT= int.parse(list[5]);
    });
  }

  @override
  void initState() {
    moLich();
  }

  @override
  void dispose() {
    luuLich();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black,)),
        backgroundColor: Colors.white,
        title: Center(child: Text("Đặt giờ nhắc nhở", style: GoogleFonts.quicksand(color: Colors.black, fontWeight: FontWeight.bold),)),
        actions: [
          SizedBox(width: 50,),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        "Ăn uống, tập luyện: ",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: Switch(
                        onChanged: (value){
                          setState(() {
                            CurrentUser.lichNhacNho = value;
                            luuLich();
                          });
                        },
                        value: CurrentUser.lichNhacNho,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              CurrentUser.lichNhacNho
              ? GestureDetector(
                onTap: (){
                  selectNhoNhoTime();
                },
                child: Container(
                  height: 80,
                  child: Text(
                    CurrentUser.nhacNhoGIO.toString() + ":" +
                        (CurrentUser.nhacNhoPHUT < 10 ? "0" + CurrentUser.nhacNhoPHUT.toString() : CurrentUser.nhacNhoPHUT.toString()),
                    style: GoogleFonts.quicksand(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              )
              : SizedBox.shrink(),

              SizedBox(height: 20,),

              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        "Đánh giá cuối ngày: ",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: Switch(
                        onChanged: (value){
                          setState(() {
                            CurrentUser.lichDaLam = value;
                            luuLich();
                          });
                        },
                        value: CurrentUser.lichDaLam,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              CurrentUser.lichDaLam
                  ? GestureDetector(
                onTap: (){
                  selectCuoiNgayTime();
                },
                child: Container(
                  height: 80,
                  child: Text(
                    CurrentUser.daLamGIO.toString() + ":" +
                        (CurrentUser.daLamPHUT < 10 ? "0" + CurrentUser.daLamPHUT.toString() : CurrentUser.daLamPHUT.toString()),
                    style: GoogleFonts.quicksand(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
                  : SizedBox.shrink(),

              SizedBox(height: 430.0 - (CurrentUser.lichNhacNho ? 80.0 : 0) - (CurrentUser.lichDaLam ? 80.0 : 0),),

              Container(
                child: Text(
                  "Vui lòng khởi động lại ứng dụng để việc cập nhật thành cồng. Cảm ơn",
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
            ),
            SizedBox(height: 8),
            Text(
              'Selected time: ${_time.format(context)}',
            ),
          ],
        ),
      ),
    );
  }
}