import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';

class GetGenCodeProvider {
  Future<String?> getGenCodeProvider() async {
    String url = ApiConstants.HOST + "/StoreConfiguration/GetGenCode";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var code = data['code'];
        return code;
      } else {
        return null;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
  }
}
