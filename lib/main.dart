import 'package:flutter/material.dart';

import 'navigator/tab_navigator.dart';

void main() => runApp(MaterialApp(
      locale: const Locale("en", "US"), //设置这个可以使输入框文字垂直居中
      supportedLocales: [
        //支持的语言
        const Locale('zh', 'CH'), // Chinese
        const Locale('en', 'US'),
      ],
      localizationsDelegates: [],
      home: TabNavigator(),
    ));
