import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/home_model_info.dart';
import 'package:flutter_trip/widget/webview.dart';

class SubNav extends StatelessWidget {
  final List<SubNavList> subNavList;

  SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    if (subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });

    int separate = (subNavList.length / 2 + 0.5).toInt();

    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //平均排列
        children: items.sublist(0, separate),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //平均排列
          children: items.sublist(separate, items.length),
        ),
      )
    ]);
  }

  Widget _item(BuildContext context, SubNavList localNavList) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebView(
                          url: localNavList.url,
                          hideAppBar: localNavList.hideAppBar,
                        )));
          },
          child: Column(
            children: <Widget>[
              Image.network(
                localNavList.icon,
                width: 18,
                height: 18,
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  localNavList.title,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              )
            ],
          ),
        ));
  }
}
