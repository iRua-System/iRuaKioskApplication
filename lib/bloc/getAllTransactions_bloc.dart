import 'dart:async';
import 'package:kiosk/dataprovider/getAllTransaction.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetAllTransactionBloc {
  StreamController getTranasctionStream = new StreamController();
  Stream get getTransaction => getTranasctionStream.stream;
  List<Transaction> transaction = [];
  Future<bool> getAllTransactionBloc(context, start, end) async {
    print("Bloc Check");
    getTranasctionStream.sink.add("Checking");
    var getProvider = GetAllTransactionProvider();
    var result =
        await getProvider.getAllTransaction(start, end).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result != null && result.length > 0) {
      transaction = result;
      getTranasctionStream.sink.add(result);
      return true;
    }
    getTranasctionStream.sink.add("Aloha");
    return false;
  }

  void dispose() {
    getTranasctionStream.close();
  }

  void searchByName(String search) {
    print(search);
    var result = transaction
        .where((element) => element.emp!.fullname.contains(search))
        .toList();
    getTranasctionStream.sink.add(result);
  }
}
