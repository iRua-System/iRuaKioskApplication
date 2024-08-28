import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/customer.dart';

class CheckMemberProvider {
  Future<Customer> checkMember(String phoneNum) async {
    String url =
        ApiConstants.HOST + "/Customers/CheckAccount?username=" + phoneNum;
    // String transactionBody = json.encode({'username': phoneNum});
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var account = data['account'];
        var accId = account['accId'];
        var username = account['username'];
        var info = data['info'];
        var fullname = info['fullname'];
        var phoneNum = info['phoneNum'];
        var photo = info['photo'];
        var cust = data['customer'];
        var cusID = cust['cusId'].toString();
        var balance = cust['balance'].toString();
        var deviceToken = cust['deviceToken'];
        var vehiclePlate = cust['vehiclePlate'];
        Customer customer = new Customer(
            accId: accId,
            username: username,
            fullname: fullname,
            phoneNum: phoneNum,
            photo: photo,
            cusId: cusID,
            balance: balance,
            vehiclePlate: vehiclePlate,
            deviceToken: deviceToken);
        return customer;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return Customer(
        cusId: "00000000-0000-0000-0000-000000000000", deviceToken: '');
  }
}
