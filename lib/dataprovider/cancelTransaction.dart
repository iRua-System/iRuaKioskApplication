import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class CancelTransactionProvider {
  Future<bool> cancelTransaction(String transactionId,actor,reason) async {
    String url = ApiConstants.HOST + "/Transaction/Cancel/" + transactionId;
    String transactionBody = json.encode({'actor': actor,'reason':reason});
    print(transactionBody);
    print(url);
    try {
      var response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: transactionBody);
          print(response.statusCode);
          print(response.body);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
    return false;
  }
}
