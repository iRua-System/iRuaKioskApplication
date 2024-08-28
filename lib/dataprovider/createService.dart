import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/vehicleType.dart';

class CreateServiceProvider {
  Future<bool> createServiceMember(Service service, List<VehicleType> prices
      ) async {
    String url = ApiConstants.HOST + "/Services/AddNewService";
      String transactionBody = json.encode({
        'serviceName': service.name,
        'image': service.photo,
        'description': service.description,
        'priceList': prices,
      });
      print(transactionBody);
      try {
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: transactionBody);
            print(response.statusCode);
        if (response.statusCode == 201) {
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
