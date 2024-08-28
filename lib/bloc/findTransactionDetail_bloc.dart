import 'dart:async';
import 'package:kiosk/dataprovider/findTransactionDetail.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FindTransactionDetailBloc {
  StreamController findTransactionDetail = new StreamController();
  Stream get findTransactionDetailStream => findTransactionDetail.stream;

  Future<bool> findTransactionDetailBloc(context, String phoneNum) async {
    findTransactionDetail.sink.add("Logging");
    print("Bloc Check");
    var findProvider = FindTransactionDetailProvider();
    var result =
        await findProvider.findTransactionDetail(phoneNum).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result != null) {
      findTransactionDetail.sink.add(result);
      return true;
    } else {
      findTransactionDetail.sink.add("Aloha");
      return false;
    }
  }

  void dispose() {
    findTransactionDetail.close();
  }
}
