import 'dart:async';

import 'package:kiosk/dataprovider/getRandomEmp.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetRandomEmpBloc {
 
  StreamController getRandomEmpStream = new StreamController.broadcast();
 
  Stream get genRandomEmp => getRandomEmpStream.stream.asBroadcastStream();

  Future<bool> getRandomEmpBloc(context) async {
    print("Bloc Check");
    var get = GetRandomEmpProvider();
    var result =
        await get.getRandomEmprovider().catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    print(result);
    if (result != null) {
      getRandomEmpStream.sink.add(result);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    getRandomEmpStream.close();
  }
}
