import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/store.dart';

class GetStoreConfigureProvider {
  Future<Store?> getStoreConfigure() async {
    String url = ApiConstants.HOST + "/StoreConfiguration/Store";
    print(url);
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        Store store = Store();
        store.address = data['address'];
        store.closeTime = data['closeHour'];
        store.openTime = data['openHour'];
        store.storeName = data['storeName'];
        store.ownerImage = data['ownerImage'];
        store.ownerName = data['ownerName'];
        store.phone = data['phone'];
        return store;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw Exception("Network");
    }
  }
}
