import 'dart:async';
import 'package:kiosk/dataprovider/cancelTransaction.dart';
import 'package:kiosk/noti/noti.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogCount.dart';

import 'package:rflutter_alert/rflutter_alert.dart';


class CancelTransactionBloc {
  StreamController cancelTransaction = new StreamController();
  StreamController isChecking = new StreamController();
  Stream get isCheckingStream => isChecking.stream;
  Stream get cancelTransactionStream => cancelTransaction.stream;

  Future<bool> cancelTransactionBloc(context, String transactionId,reason, actor, deviceToken) async {
    isChecking.sink.add("Logging");
    print("Bloc Check");
    var cancelProvider = CancelTransactionProvider();
    PushNoti noti = PushNoti();
    var result = await cancelProvider.cancelTransaction(transactionId,actor,reason).catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
      isChecking.sink.add("Done");
    });
    
    if (result) {
      isChecking.sink.add("Done");
      noti.updateNoti();
      noti.sendNotiToUser("Bạn vừa huỷ 1 đơn hàng", deviceToken);
       CountDialog.displayDialog("Success", context, "Hủy giao dịch thành công",AlertType.success,4);
      return true;
    }else{
      isChecking.sink.add("Done");
      OpenDialog.displayDialog("Error", context, "Hủy  giao dịch thất bại",AlertType.error);
    }
    return false;
  }
   void dispose() {
    cancelTransaction.close();
    isChecking.close();
  }
  
}
