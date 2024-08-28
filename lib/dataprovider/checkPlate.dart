import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';

class CheckPlateProvider {
  Future<String?> checkPlate(String plate) async {
    String url =
        ApiConstants.HOST + "/Orders/CheckVehiclePlate?VehiclePlate=" + plate;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
          print(response.statusCode);
          print(response.body);
      if (response.statusCode == 200) {
        return "OK";
      } else {
        if(response.statusCode == 400){
          final data = json.decode(response.body);
          var message = data['message'];
          if(message == "Existed"){
            return "Existed";
          }else if(message == "Blacklisted"){
            return "Blacklisted";
          }
        }
        

      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return null;
  }
}
