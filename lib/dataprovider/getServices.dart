import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/service.dart';

class GetServicesProvider {
  Future<List<Service>?> getServices(
      String vehicleTypeId, List<Service> services) async {
    String url =
        ApiConstants.HOST + "/Services/GetByVehicleId/" + vehicleTypeId;
    List<Service> list = [];
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        final listData = json.decode(response.body);
        for (var data in listData) {
          var serviceVehicleId = data['serviceVehicleId'];
          var name = data['name'];
          var description = data['description'];
          var price = data['price'].toString();
          var photo = data['photo'].toString();

          if (services
                      .where((element) => element.name!.contains(name))
                      .toList()
                      .length ==
                  0 &&
              name != "Phụ Thu") {
            Service temp = Service(
                serviceVehicleId: serviceVehicleId.toString(),
                name: name,
                description: description,
                price: price.toString(),
                vehicleName: name,
                photo: photo,
                check: false,
                prices: []);
            list.add(temp);
          }
        }
      } else {
        return null;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return list;
  }
}
