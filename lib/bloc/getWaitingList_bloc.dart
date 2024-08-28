import 'dart:async';
import 'package:kiosk/dataprovider/getWaitingList.dart';
import 'package:kiosk/models/waitingSlot.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetWaitingListBloc {
  StreamController getWaitingList = new StreamController();
  Stream get getWaitingListStream => getWaitingList.stream;
  List<WaitingSlot> list = [];
  Future<bool> getWaitingListBloc(context) async {
    print("Bloc Check");
    var getWaitingListProvider = GetWaitingListProvider();
    var result =
        await getWaitingListProvider.getWaitingList().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result!.length > 0) {
      List<WaitingSlot> limitList = [];
      if (result.length > 5) {
        for (int i = 0; i < 5; i++) {
          limitList.add(result[i]);
        }
      } else {
        for (int i = 0; i < result.length; i++) {
          limitList.add(result[i]);
        }
      }

      getWaitingList.sink.add(limitList);
      list = result;
      return true;
    } else {
      getWaitingList.sink.add("Error");
    }

    return false;
  }

  void searchByPhone(String search) {
    print(search);
    var result =
        list.where((element) => element.phonenum!.contains(search)).toList();
    List<WaitingSlot> limitList = [];
    if (result.length > 5) {
      for (int i = 0; i < 5; i++) {
        limitList.add(result[i]);
      }
    } else {
      for (int i = 0; i < result.length; i++) {
        limitList.add(result[i]);
      }
    }
    getWaitingList.sink.add(limitList);
  }

  void dispose() {
    getWaitingList.close();
  }
}
