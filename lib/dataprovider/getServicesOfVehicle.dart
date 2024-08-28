import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/vehicleType.dart';

class GetServicesOfVehicleProvider {
  Future<List<Service>> getServicesOfVehicle() async {
    String url = ApiConstants.HOST + "/Services/VehicleServices";
    List<Service> list = [];
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final listData = json.decode(response.body);
        for (var data in listData) {
          var name = data['name'];
          var vehicleId = data['id'];
          final listServices = data['services'];
          for (var service in listServices) {
            var serviceVehicleId = service['serviceVehicleId'];
            var serviceName = service['name'];
            var description = service['description'];
            var price = service['price'];
            var photo = service['photo'];
            Service temp = Service(
                name: serviceName,
                description: description,
                price: price.toString(),
                serviceVehicleId: serviceVehicleId.toString(),
                vehicleName: name,
                vehicleId: vehicleId.toString(),
                photo: photo,
                check: false,
                prices: []);
            list.add(temp);
          }
        }
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return list;
  }

  Future<List<VehicleType>> getVehicleBrand() async {
    String url = ApiConstants.HOST + "/Brands/GetAllByVehicleType";
    List<VehicleType> list = [];

    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final listData = json.decode(response.body);
        for (var data in listData) {
          List<String> brandList = [];
          var name = data['name'];
          var id = data['id'].toString();
          var listBrands = data['vehicleBrand'];
          for (var brand in listBrands) {
            String brandInfo = brand['name'];
            brandList.add(brandInfo);
          }
          VehicleType temp = VehicleType(name: name, id: id, brand: brandList);
          list.add(temp);
        }
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return list;
  }
}
