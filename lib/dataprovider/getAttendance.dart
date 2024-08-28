import 'dart:convert';

import 'package:kiosk/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/models/employee.dart';

class GetAttendanceProvider {
  Future<List<Employee>?> getAttendance() async {
    String url = ApiConstants.HOST + "/Employees/GetAttendanceList";
    print(url);
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      List<Employee> empList = [];
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        for (var emp in data) {
          var name = emp['fullname'];
          var serialNumberNfc = emp['serialNumNfc'];
          var estimatedTime = emp['estimatedTime'];
          Employee employee = Employee(
              fullname: name,
              serialNumberNfc: serialNumberNfc,
              empId: '',
              estimatedTime: estimatedTime);
          empList.add(employee);
        }
        return empList;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      print("error");
      throw Exception("Network");
    }
  }
}
