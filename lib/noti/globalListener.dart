import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:kiosk/bloc/getStoreConfigure_bloc.dart';
import 'package:kiosk/noti/noti.dart';

late StreamSubscription approve;
DatabaseReference approveRequest =
    FirebaseDatabase.instance.ref().child("takeOrder");
late StreamSubscription connect;
DatabaseReference connectRequest =
    FirebaseDatabase.instance.ref().child("connection");
bool isApproveOpen = false;
String deviceId = "waiting";
GetConfigureBloc getBloc = GetConfigureBloc();
PushNoti noti = PushNoti();
void connectToServer(context) {
  Timer.periodic(Duration(seconds: 10), (timer) {
    getBloc.getSystemBloc(context, false).then((value) {
      noti.connected("$value", deviceId);
    });
  });
}
