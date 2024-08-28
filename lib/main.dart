import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/bloc/checkAdmin_bloc.dart';
import 'package:kiosk/bloc/getAttendance_bloc.dart';
import 'dart:math';
import 'package:kiosk/bloc/getGenCode_bloc.dart';
import 'package:kiosk/bloc/getStoreConfigure_bloc.dart';
import 'package:kiosk/firebase_options.dart';
import 'package:kiosk/models/store.dart';
import 'package:kiosk/noti/globalListener.dart';
import 'package:kiosk/noti/noti.dart';
import 'package:kiosk/ui/admin/adminHome.dart';
import 'package:kiosk/ui/admin/storeConfigure.dart';
import 'package:kiosk/ui/booking/member/booked/getBookedNumber.dart';
import 'package:kiosk/ui/onlineSlot.dart';
import 'package:kiosk/ui/waitingList.dart';
import 'package:kiosk/ui/widgets/approveDialog.dart';
import 'package:kiosk/ui/widgets/closeStoreDialog.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/exitDialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dcdg/dcdg.dart';
import 'constants/appColor.dart';
import 'ui/ordermanage/findTransaction.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('vi', ''),
      ],
      navigatorKey: navigatorKey,
      title: 'Check In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: MyCheckInPage(
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class MyCheckInPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyCheckInPage({Key? key, required this.navigatorKey}) : super(key: key);
  @override
  _MyCheckInPageState createState() => _MyCheckInPageState();
}

class _MyCheckInPageState extends State<MyCheckInPage> {
  GetGenCodeBloc bloc = GetGenCodeBloc();
  late DateTime now;
  PushNoti noti = PushNoti();
  @override
  void initState() {
    final context = widget.navigatorKey.currentState?.overlay?.context;
    getBloc.getConfigureBloc(context);
    if (deviceId == "waiting") {
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();
      deviceId = String.fromCharCodes(Iterable.generate(
          50, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    }
    print("approve");

    approve = approveRequest.onChildChanged.listen((event) {
      approveRequest.once().then((DataSnapshot data) {
            DataSnapshot data = event.snapshot;
            Map<dynamic, dynamic>? value = data.value as Map<dynamic, dynamic>?;
            if (value?['approve'] == 'request') {
              String transInfo = value?['transInfo'];
              String oldEmp = value?['oldEmp'];
              String newEmp = value?['newEmp'];
              String info = "Staff " +
                  newEmp +
                  " would like to take this order " +
                  transInfo +
                  " on behalf of " +
                  oldEmp +
                  ". Do you agree with that ?";
              if (!isApproveOpen) {
                ApproveDialog.displayDialog(
                    "Warning", context, info, AlertType.info);
              }
            }
          } as FutureOr Function(DatabaseEvent value));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<DatabaseEvent>(
        future: connectRequest.once(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var dataSnapshot = snapshot.data!.snapshot;
            Map<dynamic, dynamic>? values =
                dataSnapshot.value as Map<dynamic, dynamic>?;
            String dbToken = values?['deviceId'];
            if (dbToken == deviceId) {
              connectToServer(context);
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: StreamBuilder(
                      stream: getBloc.getConfigure,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != 'NOSTORE') {
                          Store store = snapshot.data as Store;
                          return Stack(children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xff43ddfb).withOpacity(0.8),
                                      Color(0xff20b9f5),
                                    ]),
                              ),
                            ),
                            Positioned(
                              right: 50,
                              top: 30,
                              child: GestureDetector(
                                onTap: () {
                                  PasswordDialog.displayDialog(context,
                                      getBloc.getConfigureBloc(context));
                                },
                                onLongPress: () {
                                  bloc.getGenCodeBloc(context);
                                },
                                child: Container(
                                  height: height / 10,
                                  width: height / 10,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 20,
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    width: height / 15,
                                    height: height / 15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                            "assets/icons/settings.png",
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 150,
                              top: 30,
                              child: GestureDetector(
                                onDoubleTap: () {
                                  PushNoti noti = PushNoti();
                                  noti.updateNoti();
                                },
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OnlineSlotPage()));
                                },
                                child: Container(
                                  height: height / 10,
                                  width: height / 10,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 20,
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    width: height / 15,
                                    height: height / 15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                            "assets/icons/slot.png",
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 50,
                              top: 30,
                              child: Container(
                                height: height / 6,
                                width: width / 7,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/iconwhite.png"))),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 70.0),
                                child: Container(
                                  height: height / 6,
                                  width: width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        store.storeName!,
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: height / 5,
                                width: width / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      store.address!,
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      store.phone!,
                                      style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        checkInButton(snapshot.data as Store);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Counter(
                                              color: AppColor.TEXT_PHONE_NUMBER,
                                              image: "assets/icons/10.png",
                                              number: 'CHECK IN',
                                              width: width / 4,
                                              height: width / 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 50),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FindTransactionScreen()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Counter(
                                              color: AppColor.TEXT_PHONE_NUMBER,
                                              number: 'TRANSACTION MANAGEMENT',
                                              image: "assets/icons/5.png",
                                              width: width / 4,
                                              height: width / 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 50),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WaitingListScreen()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Counter(
                                              color: AppColor.TEXT_PHONE_NUMBER,
                                              image: "assets/icons/13.png",
                                              number: 'QUEUE LIST',
                                              width: width / 4,
                                              height: width / 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ]);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 7,
                              backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                            ),
                          );
                        }
                      }));
            } else {
              var dbTime = DateFormat.yMd().add_Hms().parse(values?['time']);

              getBloc.getSystemBloc(context, true).then((value) {
                if (value != null) {
                  now = value;
                  var dur = now.difference(dbTime).inSeconds;

                  if (now.isAfter(dbTime) && (dur >= 10)) {
                    connectToServer(context);
                    return Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: StreamBuilder(
                            stream: getBloc.getConfigure,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data != 'NOSTORE') {
                                Store store = snapshot.data as Store;
                                return Stack(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xff43ddfb).withOpacity(0.8),
                                            Color(0xff20b9f5),
                                          ]),
                                    ),
                                  ),
                                  Positioned(
                                    right: 50,
                                    top: 30,
                                    child: GestureDetector(
                                      onTap: () {
                                        PasswordDialog.displayDialog(context,
                                            getBloc.getConfigureBloc(context));
                                      },
                                      onLongPress: () {
                                        bloc.getGenCodeBloc(context);
                                      },
                                      child: Container(
                                        height: height / 10,
                                        width: height / 10,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                            )
                                          ],
                                        ),
                                        child: Container(
                                          width: height / 15,
                                          height: height / 15,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: AssetImage(
                                                  "assets/icons/settings.png",
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 150,
                                    top: 30,
                                    child: GestureDetector(
                                      onDoubleTap: () {
                                        PushNoti noti = PushNoti();
                                        noti.updateNoti();
                                      },
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OnlineSlotPage()));
                                      },
                                      child: Container(
                                        height: height / 10,
                                        width: height / 10,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                            )
                                          ],
                                        ),
                                        child: Container(
                                          width: height / 15,
                                          height: height / 15,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: AssetImage(
                                                  "assets/icons/slot.png",
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 50,
                                    top: 30,
                                    child: Container(
                                      height: height / 6,
                                      width: width / 7,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/icons/iconwhite.png"))),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 70.0),
                                      child: Container(
                                        height: height / 6,
                                        width: width / 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              store.storeName!,
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: height / 5,
                                      width: width / 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            store.address!,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            store.phone!,
                                            style: TextStyle(
                                                fontSize: 35,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              checkInButton(
                                                  snapshot.data as Store);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(0, 4),
                                                    blurRadius: 20,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Counter(
                                                    color: AppColor
                                                        .TEXT_PHONE_NUMBER,
                                                    image:
                                                        "assets/icons/10.png",
                                                    number: 'CHECK IN',
                                                    width: width / 4,
                                                    height: width / 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 50),
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FindTransactionScreen()));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(0, 4),
                                                    blurRadius: 20,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Counter(
                                                    color: AppColor
                                                        .TEXT_PHONE_NUMBER,
                                                    number:
                                                        'TRANSACTION MANAGEMENT',
                                                    image: "assets/icons/5.png",
                                                    width: width / 4,
                                                    height: width / 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 50),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WaitingListScreen()));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(0, 4),
                                                    blurRadius: 20,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Counter(
                                                    color: AppColor
                                                        .TEXT_PHONE_NUMBER,
                                                    image:
                                                        "assets/icons/13.png",
                                                    number: 'QUEUE LIST',
                                                    width: width / 4,
                                                    height: width / 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ]);
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 7,
                                    backgroundColor:
                                        AppColor.PRIMARY_TEXT_WHITE,
                                  ),
                                );
                              }
                            }));
                  } else if (now.isAfter(dbTime) && (dur < 10)) {
                    ExitDialog.displayDialog(
                        "Error",
                        context,
                        "This application is using in another device",
                        AlertType.error);
                  }
                }
              });
            }
          }
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: StreamBuilder(
                  stream: getBloc.getConfigure,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != 'NOSTORE') {
                      Store store = snapshot.data as Store;
                      return Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xff43ddfb).withOpacity(0.8),
                                  Color(0xff20b9f5),
                                ]),
                          ),
                        ),
                        Positioned(
                          right: 50,
                          top: 30,
                          child: GestureDetector(
                            onTap: () {
                              PasswordDialog.displayDialog(
                                  context, getBloc.getConfigureBloc(context));
                            },
                            onLongPress: () {
                              bloc.getGenCodeBloc(context);
                            },
                            child: Container(
                              height: height / 10,
                              width: height / 10,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: Container(
                                width: height / 15,
                                height: height / 15,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                        "assets/icons/settings.png",
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 150,
                          top: 30,
                          child: GestureDetector(
                            onDoubleTap: () {
                              PushNoti noti = PushNoti();
                              noti.updateNoti();
                            },
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OnlineSlotPage()));
                            },
                            child: Container(
                              height: height / 10,
                              width: height / 10,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: Container(
                                width: height / 15,
                                height: height / 15,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                        "assets/icons/slot.png",
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 30,
                          child: Container(
                            height: height / 6,
                            width: width / 7,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/icons/iconwhite.png"))),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 70.0),
                            child: Container(
                              height: height / 6,
                              width: width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    store.storeName!,
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: height / 5,
                            width: width / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  store.address!,
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  store.phone!,
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    checkInButton(snapshot.data as Store);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 20,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Counter(
                                          color: AppColor.TEXT_PHONE_NUMBER,
                                          image: "assets/icons/10.png",
                                          number: 'CHECK IN',
                                          width: width / 4,
                                          height: width / 3.85,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FindTransactionScreen()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 20,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Counter(
                                          color: AppColor.TEXT_PHONE_NUMBER,
                                          number: 'TRANSACTION MANAGEMENT',
                                          image: "assets/icons/5.png",
                                          width: width / 4,
                                          height: width / 3.85,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WaitingListScreen()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 20,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Counter(
                                          color: AppColor.TEXT_PHONE_NUMBER,
                                          image: "assets/icons/13.png",
                                          number: 'QUEUE LIST',
                                          width: width / 4,
                                          height: width / 3.85,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ]);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 7,
                          backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                        ),
                      );
                    }
                  }));
        });
  }

  checkInButton(Store store) {
    this.showDialogConfirmActive();
    var close = DateFormat("HH:mm").parse(store.closeTime!);
    var end = close;
    close = close.subtract(Duration(hours: 1));

    getBloc.getSystemBloc(context, true).then((value) {
      String val = value.toString().split(" ")[1];
      value = DateFormat.Hms().parse(val);
      if (value != null) {
        String closeMin = value.minute.toString();
        if (closeMin.length == 1) {
          closeMin = "0" + closeMin;
        }
        if (value.isAfter(close) && value.isBefore(end)) {
          Navigator.of(context).pop();
          String alert = "It is currently " +
              value.hour.toString() +
              ":" +
              closeMin +
              " and it's almost closing time. Are you sure you want to continue?";
          CloseStoreDialog.displayDialog(
              "Warning", context, alert, AlertType.warning, store);
        } else if (value.isAfter(end) || value.isAtSameMomentAs(end)) {
          print(end);
          print(value);
          Navigator.of(context).pop();
          String alert = "It is currently " +
              value.hour.toString() +
              ":" +
              closeMin +
              " and it's almost closing time. Are you sure you want to continue?";
          CloseStoreDialog.displayDialog(
              "Warning", context, alert, AlertType.warning, store);
        } else if (value.isBefore(close)) {
          GetAttendanceBloc attendanceBloc = GetAttendanceBloc();
          attendanceBloc.getAttendanceBloc(context).then((value) {
            if (value) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GetBookedNumberScreen(
                        store: store,
                      )));
            } else {
              Navigator.of(context).pop();
              OpenDialog.displayDialog("Error", context,
                  "Currently, no employees have checked in.", AlertType.error);
            }
          });
        }
      } else {
        Navigator.of(context).pop();
        OpenDialog.displayDialog("Error", context,
            "The system is experiencing issues.", AlertType.error);
      }
    });
  }

  void showDialogConfirmActive() {
    showDialog(
        barrierDismissible: true,
        context: this.context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: Text('Processing'),
            content: Container(
              height: 80,
              child: Center(
                child: Column(children: [
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please wait a moment.",
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ]),
              ),
            ),
          );
        });
  }
}

class Counter extends StatelessWidget {
  final String? number;
  final Color? color;
  final String? image;
  final double? width;
  final double? height;
  const Counter(
      {Key? key, this.color, this.number, this.image, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              height: width! / 2,
              width: width! / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image!),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              number!,
              style: TextStyle(fontSize: 30, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordDialog {
  static void displayDialog(context, reload) {
    TextEditingController passwordController = TextEditingController();
    var alertStyle = AlertStyle(
      overlayColor: Colors.black.withOpacity(0.4),
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 100),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Color(0xff20b9f5),
      ),
    );
    Alert(
        context: context,
        image: Image.asset("assets/icons/icon.png"),
        style: alertStyle,
        title: "Input your safe key",
        content: Column(
          children: <Widget>[
            Form(
              child: TextFormField(
                style: TextStyle(fontSize: 25),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  //icon: Icon(Icons.lock),
                  labelText: 'Safe key',
                ),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (passwordController.text.trim().isEmpty) {
                OpenDialog.displayDialog(
                    "Error", context, "Safe key is invalid", AlertType.error);
              } else {
                CheckAdminBloc checkBloc = CheckAdminBloc();
                String password = passwordController.text;
                checkBloc.checkAdminBloc(context, password).then((value) {
                  if (value) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => HomePage(
                                  screen: StoreConfigure(),
                                  key: null,
                                )))
                        .then((value) {
                      GetConfigureBloc getBloc = GetConfigureBloc();
                      getBloc.getConfigureBloc(context);
                    });
                  } else {
                    OpenDialog.displayDialog("Error", context,
                        "Safe key is incorrect", AlertType.error);
                  }
                });
              }
            },
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
