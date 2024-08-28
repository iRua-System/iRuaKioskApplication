import 'dart:async';

import 'package:kiosk/dataprovider/getAllFeedBack.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetAllFeedbackBloc {
  StreamController getFeedbackStream = new StreamController();
  Stream get getFeedback => getFeedbackStream.stream;
  List<Transaction> transaction = List<Transaction>.empty();
  Future<bool> getAllFeedbackBloc(context) async {
    print("Bloc Check");
    var getProvider = GetAllFeebackProvider();
    var result =
        await getProvider.getAllFeedbackTransaction().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result.length > 0) {
      transaction = result;
      getFeedbackStream.sink.add(result);
      return true;
    } else if (result.length == 0) {
      getFeedbackStream.sink.add("Aloha");
      return false;
    }
    getFeedbackStream.sink.add("Aloha");
    return false;
  }

  void dispose() {
    getFeedbackStream.close();
  }
  void searchByName(String search) {
    print(search);
    var result =
        transaction.where((element) => element.emp!.fullname.contains(search)).toList();
    getFeedbackStream.sink.add(result);
  }
}
