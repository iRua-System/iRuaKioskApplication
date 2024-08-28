import 'dart:async';


import 'package:kiosk/dataprovider/assignPrice.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AssignPriceBloc {
  StreamController assignPriceStream = new StreamController();
  Stream get assignPrice=> assignPriceStream.stream;

  Future<bool> assignPriceBloc(
      context, String servicesId, vehicleTypesId, price) async {
    print("Bloc Check");
    var assignPrice = AssignPriceProvider();
    var result = await assignPrice
        .assignPrice(servicesId, vehicleTypesId, price)
        .catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    if (result) {
      print(result);
      OpenDialog.displayDialog("Success", context, "Thêm giá dịch vụ thành công",AlertType.success);
      // Navigator.of(context).popUntil((route) => count++ >= 2);
     
      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Thêm giá dịch vụ không thành công",AlertType.error);
      return false;
    }
  }

  void dispose() {
    assignPriceStream.close();
  }
}
