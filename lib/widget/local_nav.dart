import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/home_model_info.dart';
import 'package:flutter_trip/widget/webview.dart';

class LocalNav extends StatelessWidget {
  final List<LocalNavList> localNavList;

  LocalNav({Key key, @required this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //平均排列
      children: items,
    );
  }

  Widget _item(BuildContext context, LocalNavList localNavList) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: localNavList.url,
                      statusBarColor: localNavList.statusBarColor,
                      hideAppBar: localNavList.hideAppBar,
                    )));
      },
      child: Column(
        children: <Widget>[
          Image.network(
            localNavList.icon,
            width: 32,
            height: 32,
          ),
          Text(
            localNavList.title,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          )
        ],
      ),
    );
  }
}
