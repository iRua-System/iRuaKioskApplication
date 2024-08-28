import 'dart:async';



import 'package:kiosk/dataprovider/changeSafeKey.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangeSafeKeyBloc {
  StreamController changeSafeKeyStream = new StreamController.broadcast();
  Stream get changeSafeKey => changeSafeKeyStream.stream.asBroadcastStream();

  Future<bool> changeSafeKeyBloc(context, String newPass, String oldPass) async {
    print("Bloc Check");
    var changeSafeKeyProvider = ChangeSafeKeyProvider();
    var result = await changeSafeKeyProvider.changeSafeKeyProvider(newPass, oldPass).catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
   
    if (result) {
      return true;
    } else {
      return false;
    }
  }
  
   void dispose() {
    changeSafeKeyStream.close();
  }
}
