import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/payment.dart';

class GetPaymentProvider {
  Future<List<Payment>> getPayment() async {
    String url = ApiConstants.HOST + "/Payments";
    List<Payment> list = [];
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print(response.body);
      if (response.statusCode == 200) {
        final listData = json.decode(response.body);
        for (var data in listData) {
          var id = data['id'].toString();
          var paymentType = data['paymentType'].toString();
          Payment payment = Payment(id: id, paymentType: paymentType);
          list.add(payment);
        }
        return list;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return list;
  }
}
