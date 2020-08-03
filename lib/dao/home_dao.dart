import 'dart:convert';

import 'package:flutter_trip/model/home_model_info.dart';
import 'package:http/http.dart' as http;

String HOME_URL = "http://www.devio.org/io/flutter_app/json/home_page.json";

class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //解决中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else
      throw ("数据请求异常");
  }
}
