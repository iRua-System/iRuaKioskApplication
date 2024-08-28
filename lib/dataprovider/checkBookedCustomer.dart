import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';

class CheckBookedCustomerProvider {
  Future<Transaction?> checkBookedCustomer(String phoneNum) async {
    String url = ApiConstants.HOST +
        "/Transaction/CheckinForOnline?Username=" +
        phoneNum;
    List<Service> services = [];
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var id = data['id'];
        var fullname = data['fullname'];
        var vehicleTypeId = data['vehicleTypeId'].toString();
        var vehicleType = data['vehicleType'];
        var vehiclePlate = data['vehiclePlate'];
        var bookingDate = data['bookingDate'].split("T")[1].split(":")[0] +
            ":" +
            data['bookingDate'].split("T")[1].split(":")[1];
        var listServices = data['services'];
        var price = data['price'].toString();
        for (var service in listServices) {
          var serviceVehicleId = service['serviceVehicleId'].toString();
          var serviceName = service['name'];
          var servicePrice = service['price'].toString();
          if (serviceName != "Phụ Thu") {
            Service temp = Service(
                name: serviceName,
                price: servicePrice,
                serviceVehicleId: serviceVehicleId,
                vehicleName: '',
                prices: []);
            services.add(temp);
          }
        }
        Customer customer = Customer(
            fullname: fullname,
            phoneNum: phoneNum,
            vehiclePlate: vehiclePlate,
            deviceToken: '');
        Transaction transaction = Transaction(
            bookingDate: bookingDate,
            id: id,
            vehicleId: vehicleTypeId,
            services: services,
            vehicleName: vehicleType,
            cust: customer,
            price: price);
        return transaction;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return null;
  }
}
