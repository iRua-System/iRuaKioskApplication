import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class UpdateServicePriceProvider {
  Future<bool> updateServicePriceProvider(
      String serviceVehicleId, price, bool isActive) async {
    String url = ApiConstants.HOST + "/Services/UpdatePrice/" + serviceVehicleId;
    String transactionBody = json.encode({
      'price': price,
      'isActive': isActive,
    });
    print(transactionBody);
    try {
      var response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: transactionBody);
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
