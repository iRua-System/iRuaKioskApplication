import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/bloc/getDefaultOnlineHour_bloc.dart';
import 'package:kiosk/bloc/updateDefaultOnlineHour_bloc.dart';

import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/onlineDate.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OnlineHour extends StatefulWidget {
  @override
  _OnlineHourState createState() => _OnlineHourState();
}

class _OnlineHourState extends State<OnlineHour> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  String start = '';
  String end = '';
  bool edit = false;
  GetDefaultOnlineHourBloc getBloc = GetDefaultOnlineHourBloc();
  @override
  void initState() {
    getBloc.getDefaultConfigureBloc(context);

    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController fromController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController slotController = TextEditingController();
  TimeOfDay startSelectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endSelectedTime = TimeOfDay(hour: 00, minute: 00);
  String startHour = '', startTime = '', startMinute = '';
  String endHour = '', endTime = '', endMinute = '';
  final f = new DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: width,
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor),
      // ..rotateY(isDrawerOpen ? -0.5 : 0),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDrawerOpen
              ? Color(0xff1fa2ff).withOpacity(0)
              : Color(0xff1fa2ff)),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode focusScopeNode = FocusScope.of(context);
          if (!focusScopeNode.hasPrimaryFocus) {
            focusScopeNode.unfocus();
          }
        },
        child: StreamBuilder(
            stream: getBloc.getDefaultOnlineHour,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != "NOHOUR") {
                OnlineDate date = snapshot.data as OnlineDate;
                DateTime temp = DateTime.parse(date.fromDate!);
                String day = f.format(temp);
                if (startTime == '') {
                  startHour = date.startOnline!.split(":")[0];
                  startMinute = date.startOnline!.split(":")[1];
                  startSelectedTime = TimeOfDay(
                      hour: num.tryParse(date.startOnline!.split(":")[0])!
                          .toInt(),
                      minute: num.tryParse(date.startOnline!.split(":")[1])!
                          .toInt());
                }
                if (endTime == '') {
                  endHour = date.endOnline!.split(":")[0];
                  endMinute = date.endOnline!.split(":")[1];
                  endSelectedTime = TimeOfDay(
                      hour:
                          num.tryParse(date.endOnline!.split(":")[0])!.toInt(),
                      minute:
                          num.tryParse(date.endOnline!.split(":")[1])!.toInt());
                }

                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 50),
                    child: isDrawerOpen
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 38,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.menu,
                              size: 38,
                              color: Colors.white,
                            ),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                xOffset = 220;
                                yOffset = 130;
                                scaleFactor = 0.9;
                                isDrawerOpen = true;
                              });
                            },
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: width * 0.87,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        height: height,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0, left: 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              Container(
                                width: width / 2,
                                child: Text(
                                  'Store\'s default online hours',
                                  style: TextStyle(
                                      color: Color(0xff1fa2ff),
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 3,
                                      child: Text(
                                        'Applied from  ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 70,
                                      width: width * 0.2,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 20),
                                        enabled: false,
                                        textAlign: TextAlign.right,
                                        controller: fromController..text = day,
                                        // onChanged: (value) =>{
                                        //   storeNameController.text = value
                                        // },
                                        decoration: InputDecoration(
                                          // labelText: 'Số điện thoại',
                                          // labelStyle: TextStyle(fontSize: 20),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff20b9f5),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 5,
                                              child: Text(
                                                'Start',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _selectStartTime(context);
                                            },
                                            child: Container(
                                              height: 70,
                                              width: width / 7,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                enabled: false,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 20),
                                                controller: startTime != ''
                                                    ? (startController
                                                      ..text = startTime)
                                                    : (startController
                                                      ..text = date.startOnline!
                                                              .split(":")[0] +
                                                          ":" +
                                                          date.startOnline!
                                                              .split(":")[1]),
                                                decoration: InputDecoration(
                                                  // labelText: 'Số điện thoại',
                                                  // labelStyle: TextStyle(fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff20b9f5),
                                                        width: 2.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 5,
                                              child: Text(
                                                'End',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _selectEndTime(context);
                                            },
                                            child: Container(
                                              height: 70,
                                              width: width / 7,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                enabled: false,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 20),
                                                controller: endTime != ''
                                                    ? (endController
                                                      ..text = endTime)
                                                    : (endController
                                                      ..text = date.endOnline!
                                                              .split(":")[0] +
                                                          ":" +
                                                          date.endOnline!
                                                              .split(":")[1]),
                                                decoration: InputDecoration(
                                                  // labelText: 'Số điện thoại',
                                                  // labelStyle: TextStyle(fontSize: 20),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff20b9f5),
                                                        width: 2.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 3,
                                              child: Text(
                                                'Online order quantity limit',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 70,
                                            width: width / 7,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  edit = true;
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              //enabled: false,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 20),
                                              controller: edit
                                                  ? slotController
                                                  : (slotController
                                                    ..text = date.limitedSlot!),
                                              decoration: InputDecoration(
                                                // labelText: 'Số điện thoại',
                                                // labelStyle: TextStyle(fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff20b9f5),
                                                      width: 2.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      buildButton(width),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 50,
                    top: 30,
                    child: Container(
                      height: height / 5,
                      width: width / 5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/icons/icon.png"))),
                    ),
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
            }),
      ),
    );
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: startSelectedTime);
    if (picked!.hour > num.tryParse(endHour)!.toInt() ||
        (picked.hour == num.tryParse(endHour)!.toInt() &&
            picked.minute > num.tryParse(endMinute)!.toInt())) {
      OpenDialog.displayDialog("Error", context,
          "The end time must be later than the start time.", AlertType.error);
    }
    setState(() {
      startSelectedTime = picked;
      startHour = startSelectedTime.hour.toString();
      if (startHour.length == 1) {
        startHour = "0" + startSelectedTime.hour.toString();
      }
      startMinute = startSelectedTime.minute.toString();
      print(startMinute.length);
      if (startMinute.length == 1) {
        startMinute = "0" + startSelectedTime.minute.toString();
      }
      endMinute = startMinute;
      endTime = endSelectedTime.hour.toString() +
          ":" +
          startSelectedTime.minute.toString();
      startTime = startHour + ':' + startMinute;
      startController.text = startTime;
      edit = true;
    });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    startHour = startSelectedTime.hour.toString();
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: endSelectedTime);

    if (picked!.hour < num.tryParse(startHour)!.toInt() ||
        (picked.hour == num.tryParse(startHour)!.toInt() &&
            picked.minute < num.tryParse(startMinute)!.toInt())) {
      OpenDialog.displayDialog("Error", context,
          "The end time must be later than the start time.", AlertType.error);
    } else {
      setState(() {
        endSelectedTime = picked;
        endHour = endSelectedTime.hour.toString();
        if (endHour.length == 1) {
          endHour = "0" + endSelectedTime.hour.toString();
        }
        endMinute = endSelectedTime.minute.toString();
        if (endMinute.length == 1) {
          endMinute = "0" + endSelectedTime.minute.toString();
        }
        if (startMinute != '') {
          endMinute = startMinute;
        }
        endTime = endHour + ':' + endMinute;
        endController.text = endTime;
        edit = true;
      });
    }
  }

  buildButton(width) {
    if (isDrawerOpen) {
      if (edit) {
        return Container(
          height: 60,
          width: width / 5,
          child: Text(
            'SAVE',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xff1fa2ff),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      } else {
        return Container();
      }
    } else {
      if (edit) {
        return GestureDetector(
          onTap: () {
            onSaveClick(context);
          },
          child: Container(
            height: 60,
            width: width / 5,
            child: Text(
              'SAVE',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xff1fa2ff),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  onSaveClick(context) {
    UpdateDefaultOnlineHourBloc updateBloc = UpdateDefaultOnlineHourBloc();
    String limitedSlot = num.tryParse(slotController.text)!.toInt().toString();
    updateBloc
        .updateDefaultOnlineHourBloc(
            context, startController.text, endController.text, limitedSlot)
        .then((value) {
      if (value) {
        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            edit = false;
            getBloc.getDefaultConfigureBloc(context);
          });
        });
      }
    });
  }
}
