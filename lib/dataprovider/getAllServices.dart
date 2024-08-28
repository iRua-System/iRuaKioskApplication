import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/servicePrice.dart';

class GetAllServicesProvider {
  Future<List<Service>?> getAllServices() async {
    String url = ApiConstants.HOST + "/Services/Vehicles";
    List<Service?> list = [];

    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final listData = json.decode(response.body);
        for (var data in listData) {
          List<ServicePrice> prices = [];
          var id = data['id'].toString();
          var name = data['name'];
          var description = data['description'];
          var photo = data['photo'];
          var vehicles = data['vehicles'];
          for (var vehicle in vehicles) {
            var serviceVehicleId = vehicle['serviceVehicleId'].toString();
            var vehicleName = vehicle['name'];
            var price = vehicle['price'].toString();
            var time = vehicle['estimatedTime'].toString();
            ServicePrice servicePrice = ServicePrice(
                name: vehicleName,
                price: price,
                serviceVehicleId: serviceVehicleId,
                estimatedTime: time);
            prices.add(servicePrice);
          }
          Service service = Service(
              id: id,
              name: name,
              description: description,
              photo: photo,
              prices: prices,
              vehicleName: '');
          list.add(service);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw Exception("Network");
    }
    return null;
  }
}
