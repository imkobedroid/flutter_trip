import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

// ignore: must_be_immutable
class WebView extends StatefulWidget {
  String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool exit = false;
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _streamSubscription;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void initState() {
    super.initState();
    webViewReference.close();
    _streamSubscription = webViewReference.onUrlChanged.listen((String url) {});

    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged changed) {
          switch (changed.type) {
            case WebViewState.startLoad:
              if (_isToMain(changed.url) && !exit) {
                if (widget.backForbid) {
                  webViewReference.launch(widget.url);
                } else {
                  Navigator.pop(context);
                  exit = true;
                }
              }
              break;

            default:
              break;
          }
        });

    //加载出错的监听
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {});
  }

  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    webViewReference.dispose();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text("loading..."),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backButtonColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(
        //撑满整个屏幕的组件
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? "",
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ), //双问号后面跟的是默认值
              ),
            )
          ],
        ),
      ),
    );
  }
}
