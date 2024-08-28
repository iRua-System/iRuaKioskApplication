import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/models/feedback.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';

class GetAllFeebackProvider {
  Future<List<Transaction>> getAllFeedbackTransaction() async {
    String url = ApiConstants.HOST + "/Feedback/GetAllFeedbacks";
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      List<Transaction> transactionList = [];
      if (response.statusCode == 200) {
        final dataList = json.decode(response.body);
        for (var data in dataList) {
          var trans = data['transactionInfo'];
          var id = trans['id'];
          var bookingDate = trans['bookingDate'];
          var status = trans['status'];
          var price = trans['price'].toString();
          var services = trans['services'];
          var vehiclePlate = trans['vehiclePlate'];
          var vehicleName = trans['vehicleName'];
          var vehicleId = trans['vehicleId'];
          var vehicleBrand = trans['vehicleBrand'];

          List<Service> serviceList = [];
          for (var service in services) {
            var serviceVehicleId = service['serviceVehicleId'];
            var name = service['name'];
            var servicePrice = service['price'];
            Service temp = Service(
                name: name,
                price: servicePrice.toString(),
                serviceVehicleId: serviceVehicleId.toString(),
                vehicleName: '',
                prices: []);
            serviceList.add(temp);
          }
          var employee = trans['empInfo'];
          Employee emp = Employee(fullname: '', serialNumberNfc: '', empId: '');
          if (employee != null) {
            var empId = employee['empId'];
            var nfc = employee['serialNumNfc'];
            var empName = employee['fullname'];
            emp =
                Employee(empId: empId, serialNumberNfc: nfc, fullname: empName);
          }
          var customer = trans['cusInfo'];
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
          var feed = data['feedback'];
          var transId = feed['transId'];
          var startPoint = feed['starPoint'].toString();
          var message = feed['message'];
          Feedback feedback = Feedback(
              transId: transId, starPoint: startPoint, message: message);
          print(feed['starPoint']);
          print(startPoint);
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
              feedback: feedback,
              services: serviceList);
          transactionList.add(transaction);
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
