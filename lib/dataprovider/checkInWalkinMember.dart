import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class CheckInWalkinMeberProvider {
  Future<String?> checkInWalkinMember(
      String fullname,
      serialNumNfc,
      vehiclePlate,
      vehicleBrand,
      phonenum,
      List<String> servicesVehicle,
      totalPrice) async {
    String url = ApiConstants.HOST + "/Orders/Walkin";
    List<ServiceTemp> temp = [];
    if (servicesVehicle.length > 0) {
      for (var service in servicesVehicle) {
        ServiceTemp id = ServiceTemp(id: service);
        temp.add(id);
      }
      print(temp.length);
      String transactionBody = json.encode({
        'fullname': fullname.trim(),
        'serialNumNFC': serialNumNfc,
        'vehiclePlate': vehiclePlate,
        'vehicleBrand': vehicleBrand,
        'phoneNum': phonenum,
        'totalPrice': totalPrice,
        'services': temp
      });
      print(transactionBody);
      try {
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: transactionBody);
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          var message = data['number'];
          var number = message['number'];
          //String time = message['time'];
          var total = number.toString();
          return total.toString();

          //46V3-5531
        } else {
          return null;
        }
      } catch (e) {
        print("error");
        throw Exception("Network");
      }
      // }
    } else {
      return null;
    }
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
