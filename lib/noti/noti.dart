import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class PushNoti {
  late DatabaseReference _notiRequest;
  late DatabaseReference _approveRequest;
  late StreamSubscription approveStreamSubscription;
  late DatabaseReference _connectRequest;
  late StreamSubscription connectStreamSubscription;
  PushNoti() {
    _connectRequest = FirebaseDatabase.instance.ref().child("connection");
    _approveRequest = FirebaseDatabase.instance.ref().child("takeOrder");
    _notiRequest = FirebaseDatabase.instance.ref();
  }

  void updateNoti() {
    print("noti ne");
    var rnd = new math.Random();
    var next = rnd.nextInt(999999);
    print(next);
    _notiRequest.update({
      "int": next,
    });
  }

  void updateApprove(String answer) {
    print(answer);
    _approveRequest.update({"approve": answer});
  }

  void connected(String time, deviceId) {
    _connectRequest.update({"time": time , "deviceId" : deviceId});
  }

  Future<bool> sendNotiToUser(String body, deviceToken) async {
    String url = "https://fcm.googleapis.com/fcm/send";
    String key =
        "AAAALsDeKYg:APA91bGI6dxJLQbI2-kfLS0jc_vpKHUzokMFHiVZvWimr1u6d8trNcaG_roSmB14Fys_n3vQAIky9lh1sl3oNCQOO-Lj4eavxlL5BwQADjIevEAIVtJN3wwanIPp1fnTSYb_-nINnGqC";
    String transactionBody = json.encode({
      'notification': {
        "title": "Thông báo",
        "body": body,
      },
      'priority': 'high',
      'data': {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
      'to': deviceToken
    });
    print(transactionBody);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "key=" + key
          },
          body: transactionBody);
      print(response.statusCode);
      print(response.body);
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
