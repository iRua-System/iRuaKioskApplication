import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class CheckInBookedMeberProvider {
  Future<bool> checkInBookedMember(
    String transId,
    serialNumNfc,
    vehiclePlate,
    vehicleBrand,
  ) async {
    String url = ApiConstants.HOST + "/Transaction/CheckinForOnline/" + transId;
    
      String transactionBody = json.encode({
        'serialNumNFC': serialNumNfc,
        'vehiclePlate': vehiclePlate,
        'vehicleBrand': vehicleBrand,
      });
      print(transactionBody);
      try {
        var response = await http.put(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: transactionBody);
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

class ServiceTemp {
  final String id;

  ServiceTemp({required this.id});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
    };
  }
}
