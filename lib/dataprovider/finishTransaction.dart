import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class FinishTransactionProvider {
  Future<String> finishTransaction(String transactionId, paymentId) async {
    String url = ApiConstants.HOST + "/Transaction/Finish/" + transactionId;
    String transactionBody = json.encode({'paymentsId': paymentId});
    try {
      var response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: transactionBody);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return "OK";
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        final message = data['message'];
        if (message == "No enough money") {
          return "Not enough money";
        }
      } else {}
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return "Fail";
  }
}
