import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/service.dart';

class GetExtraFeeByVehicleIdProvider {
  Future<Service?> getExtraFeeByVehicleProvider(String vehicleTypeId) async {
    String url = ApiConstants.HOST + "/Services/GetByVehicleId/" + vehicleTypeId;
    try {
      var response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var service in data){
          final name = service['name'];
          if(name == "Phụ Thu"){
            var serviceVehicleId = service['serviceVehicleId'].toString();
            var serviceId = service['serviceId'].toString();
            var description = service['description'];
            var price = service['price'].toString();
            var photo = service['photo'];

            Service temp = Service(name: name, serviceVehicleId: serviceVehicleId, id: serviceId,description: description, price: price, photo: photo, vehicleName: '', prices: []);
            return temp;
          }
        }
      } else {
        return null;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return null;
  }
}
