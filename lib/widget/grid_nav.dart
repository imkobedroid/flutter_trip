import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/home_model_info.dart';
import 'package:flutter_trip/widget/webview.dart';

//网格卡片
class GridNavView extends StatelessWidget {
  final GridNav gridNavModel;

  GridNavView({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent, //设置圆角
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> _items = [];
    if (gridNavModel == null) return _items;
    if (gridNavModel.hotel != null) {
      _items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      _items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      _items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return _items;
  }

  _gridNavItem(BuildContext context, Hotel item, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, item.mainItem));
    items.add(_doubleItems(context, item.item1, item.item2));
    items.add(_doubleItems(context, item.item3, item.item4));

    List<Widget> expandList = [];
    items.forEach((item) {
      expandList.add(Expanded(
        child: item,
        flex: 1,
      ));
    });
    Color startColor = Color(int.parse('0xff' + item.startColor));
    Color endColor = Color(int.parse('0xff' + item.endColor));
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          //线形渐变
          gradient: LinearGradient(colors: [startColor, endColor])),
      child: Row(
        children: expandList,
      ),
    );
  }

  _mainItem(BuildContext context, LocalNavList localNavList) {
    return _wrapGesture(
        context,
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Image.network(
              localNavList.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                localNavList.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        localNavList);
  }

  _doubleItems(BuildContext context, Item1 topItem, Item1 bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, false))
      ],
    );
  }

  _item(BuildContext context, Item1 item, bool first) {
    BorderSide borderSide = new BorderSide(color: Colors.white, width: 0.8);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        child: _wrapGesture(
            context,
            Center(
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            LocalNavList(
                icon: item.icon,
                title: item.title,
                url: item.url,
                statusBarColor: item.statusBarColor,
                hideAppBar: item.hideAppBar)),
        decoration: BoxDecoration(
          border: Border(
              left: borderSide, bottom: first ? borderSide : BorderSide.none),
        ),
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, LocalNavList model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: model.url,
                      statusBarColor: model.statusBarColor,
                      hideAppBar: model.hideAppBar,
                      title: model.title,
                    )));
      },
      child: widget,
    );
  }
}
