import 'dart:async';

import 'package:kiosk/dataprovider/createWalkinMember.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreateWalkinMemberBloc {
  StreamController createInWalkinMember = new StreamController();
  StreamController isChecking = new StreamController();
  Stream get createWalkinMemberStream => createInWalkinMember.stream;
  Stream get isCheckingStream => isChecking.stream;

  Future<bool> createWalkinMemberBloc(context, String fullname, phoneNum) async {
    isChecking.sink.add("Checking");
    print("Bloc Check");
    var checkProvider = CreateWalkinMeberProvider();
    var result = await checkProvider.createWalkinMember(fullname,phoneNum).catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    print("ket qua " + result.toString());
    if (result == true) {
      print(result);
      OpenDialog.displayDialog(
          "Success", context, "Đăng ký thành công",AlertType.success);
      isChecking.sink.add("Done");
      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Đăng ký không thành công",AlertType.error);
          print("alo");
          isChecking.sink.add("Done");
      return false;
    } 
  }
   void dispose() {
    isChecking.close();
    createInWalkinMember.close();
  }
}
