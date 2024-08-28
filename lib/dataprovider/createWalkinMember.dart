import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class CreateWalkinMeberProvider {
  Future<bool> createWalkinMember(String fullname, phoneNum
      ) async {
    String url = ApiConstants.HOST + "/Customers/WalkinRegister";
      String transactionBody = json.encode({
        'fullname': fullname,
        'phoneNum': phoneNum,
      });
      print(transactionBody);
      try {
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: transactionBody);
            print(response.statusCode);
        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          var message = data['msg'];
          if (message == "Success") {
            return true;
          }
          return false;
        } else {
          return false;
        }
      } catch (e) {
        print("error");
        throw Exception("Network");
      }
      // }
    
  }
}
