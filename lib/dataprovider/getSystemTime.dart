import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';

class GetSystemTimeProvider {
  Future<String?> getSystemTimeProvider() async {
    String url = ApiConstants.HOST + "/OnlineSchedule/GetSystemTime";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var code = data['today'];
        return code;
      } else {
        return null;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
  }
}
