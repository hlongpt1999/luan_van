import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

List<String> _bottomBarTitle = ['Home', 'Evaluate', 'Message','Statistical'];
List<IconData> _bottomBarIcons = [Icons.home_outlined, Icons.favorite_border, Icons.message_outlined, AntDesign.linechart];

class HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;
  double _bottomTexSize = 12;
  PageController _pageController = new PageController();

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Expanded(
      child: Text(
        'Home',
        style: optionStyle,
      ),
    ),
    Expanded(
      child: Text(
      'Likes',
      style: optionStyle,
    ),),
    Expanded(
      child: Text(
        'Search',
        style: optionStyle,
      ),
    ),
    Expanded(
      child: Text(
        'Profile',
        style: optionStyle,
      ),
    ),
  ];

  // child: _widgetOptions.elementAt(_selectedIndex),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (page){
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
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
                  });
                }),
          ),
        ),
      ),
    );
  }
}