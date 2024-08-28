import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class AssignPriceProvider {
  Future<bool> assignPrice(String servicesId, vehicleTypesId, price) async {
    String url = ApiConstants.HOST + "/Services/AssignPrice";
    String transactionBody =
        json.encode({'servicesId': servicesId, 'vehicleTypesId': vehicleTypesId, 'price' : price});
    print(transactionBody);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: transactionBody);
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

