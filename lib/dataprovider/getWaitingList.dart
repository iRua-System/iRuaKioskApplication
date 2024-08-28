import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/waitingSlot.dart';

class GetWaitingListProvider {
  Future<List<WaitingSlot>?> getWaitingList() async {
    String url = ApiConstants.HOST + "/Transaction/GetWaitingList";

    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<WaitingSlot> list = [];
        final data = json.decode(response.body);
        for (var slots in data) {
          WaitingSlot slot = new WaitingSlot();
          slot.cusInfo = slots.cusInfo;
          slot.number = slots.no;
          slot.phonenum = slots.phoneNumber;
          list.add(slot);
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
