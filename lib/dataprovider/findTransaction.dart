import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';

class FindTransactionProvider {
  Future<List<Transaction>> findTransaction(String phoneNum) async {
    String url =
        ApiConstants.HOST + "/Transaction/GetTransByPhone?Username=" + phoneNum;
    print(url);
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      print(response.body);
      List<Transaction> transactionList = [];
      if (response.statusCode == 200) {
        final dataList = json.decode(response.body);
        for (var data in dataList) {
          var status = data['status'];
          if (status != "Cancel") {
            var id = data['id'];
            var bookingDate = data['bookingDate'];

            var price = data['price'].toString();
            var services = data['services'];
            var vehiclePlate = data['vehiclePlate'];
            var vehicleName = data['vehicleName'];
            var vehicleId = data['vehicleId'];
            var vehicleBrand = data['vehicleBrand'];
            List<Service> serviceList = [];
            for (var service in services) {
              var serviceVehicleId = service['serviceVehicleId'];
              var name = service['name'];
              var servicePrice = service['price'];
              var isNew = service['isNew'];
              Service temp = Service(
                  name: name,
                  price: servicePrice.toString(),
                  isNew: isNew,
                  serviceVehicleId: serviceVehicleId.toString(),
                  vehicleName: '',
                  prices: []);
              serviceList.add(temp);
            }
            var employee = data['empInfo'];
            Employee emp =
                Employee(fullname: '', serialNumberNfc: '', empId: '');
            if (employee != null) {
              var empId = employee['empId'];
              var nfc = employee['serialNumNfc'];
              var empName = employee['fullname'];
              emp = Employee(
                  empId: empId, serialNumberNfc: nfc, fullname: empName);
            }

            var customer = data['cusInfo'];
            var cusId = customer['cusId'];
            var cusName = customer['fullname'];
            var balance = customer['balance'];
            var phoneNum = customer['phoneNum'];
            var deviceToken = customer['deviceToken'];
            Customer cust = Customer(
              fullname: cusName,
              balance: balance.toString(),
              cusId: cusId,
              phoneNum: phoneNum,
              deviceToken: deviceToken,
            );

            Transaction transaction = Transaction(
                id: id.toString(),
                bookingDate: bookingDate,
                status: status,
                price: price.toString(),
                cust: cust,
                vehicleName: vehicleName,
                vehiclePlate: vehiclePlate,
                emp: emp,
                vehicleId: vehicleId.toString(),
                vehicleBrand: vehicleBrand,
                services: serviceList);
            transactionList.add(transaction);
          }
        }

        return transactionList;
      } else {
        return transactionList;
      }
    } catch (e) {
      print(e.toString());
      print("error");
      throw Exception("Network");
    }
  }
}
