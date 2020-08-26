import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/HomePage.dart';
import 'package:flutter_trip/pages/MyPage.dart';
import 'package:flutter_trip/pages/SearchPage.dart';
import 'package:flutter_trip/pages/TravelPage.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  // ignore: non_constant_identifier_names
  final MaterialColor _default_color = Colors.grey;

  // ignore: non_constant_identifier_names
  final MaterialColor _active_color = Colors.blue;
  int _currentIndex = 0;

  final PageController _tabController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _tabController,
        children: <Widget>[
          HomePage(),
          SearchPage(
            hideLeft: true,
          ),
          TravelPage(),
          MyPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            _tabController.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _default_color,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: _active_color,
                ),
                title: Text(
                  "首页",
                  style: TextStyle(
                      color:
                          _currentIndex != 0 ? _default_color : _active_color),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _default_color,
                ),
                activeIcon: Icon(
                  Icons.search,
                  color: _active_color,
                ),
                title: Text(
                  "搜索",
                  style: TextStyle(
                      color:
                          _currentIndex != 1 ? _default_color : _active_color),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.camera_alt,
                  color: _default_color,
                ),
                activeIcon: Icon(
                  Icons.camera_alt,
                  color: _active_color,
                ),
                title: Text(
                  "旅拍",
                  style: TextStyle(
                      color:
                          _currentIndex != 2 ? _default_color : _active_color),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: _default_color,
                ),
                activeIcon: Icon(
                  Icons.account_circle,
                  color: _active_color,
                ),
                title: Text(
                  "我的",
                  style: TextStyle(
                      color:
                          _currentIndex != 3 ? _default_color : _active_color),
                ))
          ]),
    );
  }
}
