import 'dart:async';
import 'package:kiosk/dataprovider/getAllEmployee.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetAllEmployeeBloc {
  StreamController getEmployeeStream = new StreamController();
  Stream get getEmployee=> getEmployeeStream.stream;
  Future<List<Employee>?> getAllEmployeeBloc(context) async {
    print("Bloc Check");
    var getProvider = GetAllEmployeeProvider();
    var result = await getProvider
        .getAllEmployee()
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result !=null) {
      getEmployeeStream.sink.add(result);
      return result;
    }
    return null;
  }

  void dispose() {
    getEmployeeStream.close();
  }
}
