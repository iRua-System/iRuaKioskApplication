import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/onlineDate.dart';


class GetDefaultOnlineHourProvider {
  Future<OnlineDate?> getDefaultOnlineHour() async {
    String url = ApiConstants.HOST + "/OnlineSchedule/GetOnlineTime";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var fromDate = data['fromDate'];
        var endDate = data['endDate'];
        var startOnline = data['startOnline'];
        var endOnline = data['endOnline'];
        var limitedSlot = data['limitedSlot'].toString();
        OnlineDate date = OnlineDate(fromDate: fromDate,endDate: endDate,startOnline: startOnline,endOnline: endOnline, limitedSlot: limitedSlot);
        return date;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw Exception("Network");
    }
  }
}
