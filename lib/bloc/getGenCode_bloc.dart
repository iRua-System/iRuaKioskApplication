import 'dart:async';

import 'package:kiosk/dataprovider/getGenCode.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetGenCodeBloc {
 
  StreamController genCodeStream = new StreamController();
 
  Stream get genCode => genCodeStream.stream.asBroadcastStream();

  Future<bool> getGenCodeBloc(context) async {
    print("Bloc Check");
    var getGenCode = GetGenCodeProvider();
    var result =
        await getGenCode.getGenCodeProvider().catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    print(result);
    if (result != null) {
      OpenDialog.displayDialog("Mã Quản Lí", context, result, AlertType.info);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    genCodeStream.close();
  }
}
