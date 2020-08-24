import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model_info.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultString = "";
  double appBarAlpha = 0;
  List<LocalNavList> localNavListInfo;
  GridNav gridNavModel;
  SalesBox salesBox;
  List<SubNavList> subNavList;
  List<BannerList> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        resultString = JsonCodec().encode(homeModel);
        localNavListInfo = homeModel.localNavList;
        gridNavModel = homeModel.gridNav;
        _images = homeModel.bannerList;
        subNavList = homeModel.subNavList;
        salesBox = homeModel.salesBox;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                    child: NotificationListener(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification &&
                              notification.depth == 0) {
                            _onScroll(notification.metrics.pixels);
                          }
                          return true;
                        },
                        child: _listView()),
                    onRefresh: _handleRefresh)),
            _appBar
          ],
        ),
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

  Widget _listView() {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavListInfo)),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNavView(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBoxView(salesBox: salesBox),
        )
      ],
    );
  }

  Widget get _appBar {
    return Opacity(
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
    );
  }

  get _banner => Container(
        height: 160,
        child: Swiper(
          itemCount: _images.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            BannerList banner = _images[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebView(
                              url: banner.url,
                              statusBarColor: banner.statusBarColor,
                              hideAppBar: banner.hideAppBar,
                            )));
              },
              child: Image.network(banner.icon, fit: BoxFit.fill),
            );
          },
          pagination: SwiperPagination(), //指示器
        ),
      );
}
