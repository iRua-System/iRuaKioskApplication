import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/models/feedback.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';

class GetAllTransactionProvider {
  Future<List<Transaction>?> getAllTransaction(String start, end) async {
    // start = start.split(" ")[0];
    // end = end.split(" ")[0];

    String url = ApiConstants.HOST +
        "/Transaction/GetHistoryTransaction?startDate=" +
        convert(start) +
        "&endDate=" +
        convert(end);
    print(url);
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      List<Transaction> transactionList = [];
      if (response.statusCode == 200) {
        final dataList = json.decode(response.body);
        for (var data in dataList) {
          var trans = data['transactionInfo'];
          var id = trans['id'].toString();
          //var bookingDate = trans['bookingDate'];
          var finishedDate = trans['finishedDate'];
          var payment = trans['payment'];
          var status = trans['status'];
          var price = trans['price'].toString();
          var services = trans['services'];
          var vehiclePlate = trans['vehiclePlate'];
          var vehicleName = trans['vehicleName'];
          var vehicleId = trans['vehicleId'].toString();
          var vehicleBrand = trans['vehicleBrand'];

          List<Service> serviceList = [];
          for (var service in services) {
            var serviceVehicleId = service['serviceVehicleId'].toString();
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
            var empId = employee['empId'].toString();
            var nfc = employee['serialNumNfc'];
            var empName = employee['fullname'];
            emp =
                Employee(empId: empId, serialNumberNfc: nfc, fullname: empName);
          }
          var customer = trans['cusInfo'];
          var cusId = customer['cusId'].toString();
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
          Feedback feedback = Feedback();
          if (feed.length > 0) {
            var transId = feed['transId'].toString();
            var startPoint = feed['starPoint'].toString();
            var message = feed['message'];
            feedback = Feedback(
                transId: transId, starPoint: startPoint, message: message);
          }
          Transaction transaction = Transaction(
              id: id.toString(),
              //bookingDate: bookingDate,
              status: status,
              price: price.toString(),
              cust: cust,
              vehicleName: vehicleName,
              vehiclePlate: vehiclePlate,
              emp: emp,
              vehicleId: vehicleId.toString(),
              vehicleBrand: vehicleBrand,
              feedback: feedback,
              finishedDate: finishedDate,
              payment: payment,
              services: serviceList);
          transactionList.add(transaction);
        }

        return transactionList;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      print("error");
      throw Exception("Network");
    }
  }

  String convert(String temp) {
    var month = temp.split("/")[1];
    var date = temp.split("/")[0];
    var year = temp.split("/")[2];
    return month + "-" + date + "-" + year;
  }
}
