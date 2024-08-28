
import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';

class ChangeSafeKeyProvider {
  Future<bool> changeSafeKeyProvider(String newPass, oldPass) async {
    String url = ApiConstants.HOST + "/StoreConfiguration/ChangeSafeKey?SafeKey=" + newPass +"&OldSafeKey="+oldPass;
    try {
      var response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
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
