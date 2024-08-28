import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';

class CheckAdminProvider {
  Future<bool> checkAdmin(String password) async {
    String url =
        ApiConstants.HOST + "/Admin/Check/";
        String transactionBody =json.encode({'password': password});
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},body: transactionBody);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
  }
}
