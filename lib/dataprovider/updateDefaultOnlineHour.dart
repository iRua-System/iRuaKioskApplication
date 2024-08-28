import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class UpdateDefaultOnlineHourProvider {
  Future<bool> updateDeafultOnlineHour(String start, end, limitedSlot) async {
    String url = ApiConstants.HOST + "/OnlineSchedule/NewSetting";
    String transactionBody =
        json.encode({'startOnline': start, 'endOnline': end,'limitedSlot':limitedSlot });
    print(transactionBody);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: transactionBody);
          print(response.body);
          print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    // }
  }
}
