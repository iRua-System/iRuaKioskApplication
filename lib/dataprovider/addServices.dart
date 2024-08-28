import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class AddServiceProvider {
  Future<bool> addService(
      String transId, List<String> servicesVehicle, bool isNew) async {
    String url = ApiConstants.HOST + "/Transaction/AddMoreService";
    List<ServiceTemp> temp = [];
    if (servicesVehicle.length > 0) {
      for (var service in servicesVehicle) {
        ServiceTemp id = ServiceTemp(id: service, isNew: isNew.toString());
        temp.add(id);
      }
      print(temp.length);
      String transactionBody = json.encode({
        'transId': transId.trim(),
        'serviceList': temp,
      });
      print(transactionBody);
      try {
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: transactionBody);
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
    } else {
      return false;
    }
  }
}

class ServiceTemp {
  final String id;
  final String isNew;

  ServiceTemp({required this.id, required this.isNew});

  Map<String, dynamic> toJson() {
    return {"id": this.id, "isNew": this.isNew};
  }
}
