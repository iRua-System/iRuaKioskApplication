import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/employee.dart';

class GetAllEmployeeProvider {
  Future<List<Employee>?> getAllEmployee() async {
    String url = ApiConstants.HOST + "/Employees/GetEmployeeList";
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      List<Employee> list = [];
      if (response.statusCode == 200) {
        final dataList = json.decode(response.body);
        for (var data in dataList) {
          var empId = data['empId'];
          var serialNumNfc = data['serialNumNfc'];
          var fullname = data['fullname'];
          Employee emp = Employee(
              empId: empId, serialNumberNfc: serialNumNfc, fullname: fullname);
          list.add(emp);
        }
        return list;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Network");
    }
  }
}
