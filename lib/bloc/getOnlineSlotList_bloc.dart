import 'dart:async';

import 'package:kiosk/dataprovider/getOnlineSlotList.dart';
import 'package:kiosk/dataprovider/getSystemTime.dart';
import 'package:kiosk/models/onlineSlotPerHour.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetOnlineSlotListBloc {
  StreamController getOnlineSlotListStream = new StreamController.broadcast();
  Stream get getOnlineSlotList =>
      getOnlineSlotListStream.stream.asBroadcastStream();

  Future<bool> getOnlineSlotListBloc(context) async {
    print("Bloc Check");
    var getConfigure = GetOnlineSlotListProvider();
    var result = await getConfigure.getOnlineSlotList().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result != null) {
      //getOnlineSlotListStream.sink.add(result);
      var sysTimeProvider = GetSystemTimeProvider();
      var temp = await sysTimeProvider.getSystemTimeProvider();
      if (temp != null) {
        List<OnlineSlotPerHour> list = [];
        final currentTime = DateTime(
            2024,
            1,
            1,
            num.tryParse(temp.split(":")[0])?.toInt() ?? 0,
            num.tryParse(temp.split(":")[1])?.toInt() ?? 0);
        // final currentTime = DateTime(2020, 1, 1, 15, 00);
        final morningShift = DateTime(2020, 1, 1, 12, 59);
        final eveningShift = DateTime(2020, 1, 1, 17, 59);
        final nightShift = DateTime(2020, 1, 1, 23, 00);
        if (currentTime.isBefore(morningShift)) {
          for (var data in result) {
            final tempTime = DateTime(
                2024,
                1,
                1,
                num.tryParse(temp.split(":")[0])?.toInt() ?? 0,
                num.tryParse(temp.split(":")[1])?.toInt() ?? 0);
            if (tempTime.isBefore(morningShift)) {
              list.add(data);
            }
          }
        } else if (currentTime.isAfter(morningShift) &&
            currentTime.isBefore(eveningShift)) {
          for (var data in result) {
            final tempTime = DateTime(
                2024,
                1,
                1,
                num.tryParse(temp.split(":")[0])?.toInt() ?? 0,
                num.tryParse(temp.split(":")[1])?.toInt() ?? 0);
            if (tempTime.isAfter(morningShift) &&
                tempTime.isBefore(eveningShift)) {
              list.add(data);
            }
          }
        } else if (currentTime.isAfter(eveningShift) &&
            currentTime.isAfter(eveningShift)) {
          for (var data in result) {
            final tempTime = DateTime(
                2024,
                1,
                1,
                num.tryParse(temp.split(":")[0])?.toInt() ?? 0,
                num.tryParse(temp.split(":")[1])?.toInt() ?? 0);
            print(data.time);
            if (tempTime.isAfter(eveningShift) &&
                tempTime.isBefore(nightShift)) {
              list.add(data);
            }
          }
        } else {
          getOnlineSlotListStream.sink.add("Empty");
          return false;
        }
        getOnlineSlotListStream.sink.add(list);
        return true;
      }
      return false;
    } else {
      getOnlineSlotListStream.sink.add("ERROR");
      return false;
    }
  }

  void dispose() {
    getOnlineSlotListStream.close();
  }
}
