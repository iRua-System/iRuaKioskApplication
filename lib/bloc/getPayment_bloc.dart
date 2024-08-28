import 'dart:async';

import 'package:kiosk/dataprovider/getPayment.dart';
import 'package:kiosk/models/payment.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetPaymentBloc {
  StreamController getPaymentStream = new StreamController.broadcast();
  Stream get getPayment => getPaymentStream.stream.asBroadcastStream();

  Future<bool> getPaymentBloc(context) async {
    print("Bloc Check");
    var getPaymentProvider = GetPaymentProvider();
    var result = await getPaymentProvider.getPayment().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result.length > 0) {
      List<Payment> payList = [];
      payList = result;
      getPaymentStream.sink.add(payList);
      return true;
    } else {
      getPaymentStream.sink.add("NOPAYMENT");
      return false;
    }
  }

  void dispose() {
    getPaymentStream.close();
  }
}
