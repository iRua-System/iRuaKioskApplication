import 'dart:async';

import 'package:kiosk/dataprovider/getAttendance.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetAttendanceBloc {
  StreamController getAttendanceStream = new StreamController.broadcast();
  Stream get getAttendance => getAttendanceStream.stream.asBroadcastStream();

  Future<bool> getAttendanceBloc(context) async {
    print("Bloc Check");
    var getAttendanceProvider = GetAttendanceProvider();
    var result =
        await getAttendanceProvider.getAttendance().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result != null && result.length > 0) {
      List<Employee> employeeList = [];
      employeeList = result;
      getAttendanceStream.sink.add(employeeList);
      return true;
    } else {
      getAttendanceStream.sink.add("NOEMPLOYEE");
      return false;
    }
  }

  void dispose() {
    getAttendanceStream.close();
  }
}
