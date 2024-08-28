import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/service.dart';

class UpdateServiceProvider {
  Future<bool> updateServiceProvider(
      Service service) async {
    String url = ApiConstants.HOST + "/Services/UpdateService/" + service.id!;
    String transactionBody = json.encode({
      'serviceName': service.name,
      'image': service.photo,
      'description': service.description,
      'priceList': service.prices,
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
      print(e);
      throw Exception("Network");
    }
    
    // }
  }
}
