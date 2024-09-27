import 'dart:async';
import 'package:kiosk/dataprovider/findTransaction.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FindTransactionBloc {
  StreamController findTransaction = new StreamController();
  Stream get findTransactionStream => findTransaction.stream;

  Future<bool> findTransactionBloc(context, String phoneNum) async {
    findTransaction.sink.add(null);
    print("Bloc Check");
    var findProvider = FindTransactionProvider();
    var result =
        await findProvider.findTransaction(phoneNum).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result.length > 0) {
      findTransaction.sink.add(result);
      return true;
    } else {
      findTransaction.sink.add(null);
      return false;
    }
  }

  void dispose() {
    findTransaction.close();
  }
}
