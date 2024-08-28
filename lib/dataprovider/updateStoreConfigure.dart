import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/store.dart';

class UpdateStoreProvider {
  Future<bool> updateStoreProvider(Store store) async {
    String url = ApiConstants.HOST + "/StoreConfiguration/UpdateStoreConfiguration";
    String transactionBody = json.encode({
      'storeName': store.storeName,
      'address': store.address,
      'phone': store.phone,
      'ownerName': store.ownerName,
      'ownerImage': store.ownerImage,
      'openHour' : store.openTime,
      'closeHour' : store.closeTime
    });
    print(transactionBody);
    try {
      var response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: transactionBody);
          print(response.statusCode);
          print(response.body);
      if (response.statusCode == 200) {
        
        return true;
        //46V3-5531
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
