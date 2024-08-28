import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;

class RemoveServiceProvider {
  Future<bool> removeService(String transId, String servicesVehicleId) async {
    String url = ApiConstants.HOST + "/Transaction/RemoveService?TransId=" + transId+"&Service.Id="+ servicesVehicleId;
    try {
      var response = await http.delete(Uri.parse(url),
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
    // }
  }
}

class ServiceTemp {
  final String id;

  ServiceTemp({required this.id});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
    };
  }
}
