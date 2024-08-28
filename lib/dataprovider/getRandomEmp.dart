import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/models/employee.dart';

class GetRandomEmpProvider {
  Future<Employee?> getRandomEmprovider() async {
    String url = ApiConstants.HOST + "/Orders/GetRandomEmp";
    try {
      var response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var name = data['empName'];
        var serialNumberNfc = data['serialNFC'];
        print(name);
        Employee employee = Employee(fullname: name, serialNumberNfc: serialNumberNfc, empId: '');
        return employee;
      } else {
        return null;
      }
    } catch (e) {
      print("error");
      throw Exception("Network");
    }
  }
}
