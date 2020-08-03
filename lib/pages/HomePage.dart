import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model_info.dart';
import 'package:flutter_trip/widget/local_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultString = "";
  double appBarAlpha = 0;
  List<LocalNavList> LocalNavListInfo;

  final List _images = [
    "http://www.devio.org/img/avatar.png",
    "http://www.devio.org/img/avatar.png",
    "http://www.devio.org/img/avatar.png"
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

//  void loadData() {
//    HomeDao.fetch().then((result) {
//      setState(() {
//        resultString = json.encode(result);
//      });
//    }).catchError((e) {
//      setState(() {
//        resultString = e.toString();
//      });
//    });
//  }
  void loadData() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        resultString = JsonCodec().encode(homeModel);
        LocalNavListInfo = homeModel.localNavList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification &&
                        notification.depth == 0) {
                      _onScroll(notification.metrics.pixels);
                    }
                    return true;
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 160,
                        child: Swiper(
                          itemCount: _images.length,
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(_images[index],
                                fit: BoxFit.fill);
                          },
                          pagination: SwiperPagination(), //指示器
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                          child: LocalNav(localNavList: LocalNavListInfo)),
                      Container(
                        height: 800,
                        child: ListTile(
                          title: Text(resultString),
                        ),
                      )
                    ],
                  ))),
          Opacity(
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("首页"),
                ),
              ),
            ),
            opacity: appBarAlpha,
          )
        ],
      ),
    );
  }

  void _onScroll(double pixels) {
    double alpha = pixels / 100;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }
}
