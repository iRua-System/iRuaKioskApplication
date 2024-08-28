import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/onlineSlot.dart';
import 'package:kiosk/models/onlineSlotPerHour.dart';

class GetOnlineSlotListProvider {
  Future<List<OnlineSlotPerHour>?> getOnlineSlotList() async {
    String url = ApiConstants.HOST + "/Transaction/GetOnlSlotList";

    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<OnlineSlotPerHour> list = [];

        final data = json.decode(response.body);
        for (var time in data) {
          var startTime = time['startTime'].split(":")[0] +
              ":" +
              time['startTime'].split(":")[1];
          var onlineTransList = time['onlineTransList'];
          List<OnlineSlot> online = [];
          for (var data in onlineTransList) {
            var phone = data['phoneNumber'];
            var vehicleName = data['vehicleName'];
            OnlineSlot slot =
                OnlineSlot(phone: phone, vehicleName: vehicleName);
            online.add(slot);
          }

          OnlineSlotPerHour hour =
              OnlineSlotPerHour(time: startTime, transList: online);

          list.add(hour);
        }
        return list;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw Exception("Network");
    }
  }
}
