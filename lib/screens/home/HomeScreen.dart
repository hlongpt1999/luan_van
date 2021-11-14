import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:luan_van/components/Constants.dart';
import 'package:luan_van/screens/home/components/DietListView.dart';
import 'package:luan_van/screens/home/components/TabHomeScreen.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:luan_van/screens/home/components/TabMessageScreen.dart';
import 'package:luan_van/screens/home/components/TabStatisticalScreen.dart';

import 'components/MyDrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

List<String> _bottomBarTitle = ['Trang chủ', 'Đánh giá', 'Nhắn tin', 'Thống kê'];
List<IconData> _bottomBarIcons = [
  Icons.home_outlined,
  Icons.list_alt_outlined,
  Icons.message_outlined,
  AntDesign.linechart
];

class HomeScreenState extends State<HomeScreen> {
  var title = "Tiêu đề";
  int _selectedIndex = 0;
  double _bottomTexSize = 12;
  PageController _pageController = new PageController();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();


  @override
  void initState() {
    title = _bottomBarTitle[0];
    super.initState();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    TabHomeScreen(),
    Expanded(
      child: Text(
        'Đánh giá',
        style: optionStyle,
      ),
    ),
    TabMessageScreen(),
   TabStatisticalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorBackgroundTab,
      body: SliderMenuContainer(
        appBarHeight: MySize.heightAppBar,
        appBarColor: Colors.white,
        key: _key,
        sliderMenuOpenSize: MediaQuery.of(context).size.width * 3/4,
        title: Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        sliderMenu: MyDrawer(),
        sliderMain: PageView(
          controller: _pageController,
          children: _widgetOptions,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
              title = _bottomBarTitle[page];
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100],
                tabs: [
                  GButton(
                    icon: _bottomBarIcons[0],
                    text: _bottomBarTitle[0],
                    textStyle: TextStyle(fontSize: _bottomTexSize),
                  ),
                  GButton(
                    icon: _bottomBarIcons[1],
                    text: _bottomBarTitle[1],
                    textStyle: TextStyle(fontSize: _bottomTexSize),
                  ),
                  GButton(
                    icon: _bottomBarIcons[2],
                    text: _bottomBarTitle[2],
                    textStyle: TextStyle(fontSize: _bottomTexSize),
                  ),
                  GButton(
                    icon: _bottomBarIcons[3],
                    text: _bottomBarTitle[3],
                    textStyle: TextStyle(fontSize: _bottomTexSize),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.jumpToPage(index);
                    title = _bottomBarTitle[index];
                    getData();
                  });
                }),
          ),
        ),
      ),
    );
  }


}


