import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kiosk/bloc/checkInWalkinMember_bloc.dart';
import 'package:kiosk/bloc/getAttendance_bloc.dart';
import 'package:kiosk/bloc/getRandomEmp_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/autoComplete.dart';
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/helper.dart';
import 'package:kiosk/ui/widgets/stepBox.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetWalkinCheck extends StatefulWidget {
  final Customer cust;
  final List<Service> listService;
  final int totalPrice;
  final Service extra;

  const GetWalkinCheck(
      {Key? key,
      required this.cust,
      required this.listService,
      required this.totalPrice,
      required this.extra})
      : super(key: key);

  @override
  _GetWalkinCheck createState() => _GetWalkinCheck();
}

class _GetWalkinCheck extends State<GetWalkinCheck> {
  CheckInWalkinMemberBloc bloc = CheckInWalkinMemberBloc();
  TextEditingController empController = TextEditingController();
  GetAttendanceBloc attendanceBloc = GetAttendanceBloc();
  GetRandomEmpBloc randomBloc = GetRandomEmpBloc();
  late String emp;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Employee> empList = [];
  bool selectEmp = false;
  bool edit = false;
  int price = 0;
  bool onSelect = false;
  @override
  void initState() {
    print(widget.extra.name);
    print(widget.cust.deviceToken);

    emp = '';
    price = widget.totalPrice;
    attendanceBloc.getAttendanceBloc(context);
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    if (selectEmp) {
      bool check = widget.listService
              .where((element) => element.name!.contains(widget.extra.name!))
              .toList()
              .length >
          0;
      setState(() {
        if (!check) {
          widget.listService.add(widget.extra);
          print("Cong tien ne");
          price = price + num.tryParse(widget.extra.price!)!.toInt();
          print(price);
        }
      });
    } else {
      setState(() {
        bool check = widget.listService
                .where((element) => element.name!.contains(widget.extra.name!))
                .toList()
                .length >
            0;
        if (check) {
          widget.listService.remove(widget.extra);
          print("tru tien ne");
          price = price - num.tryParse(widget.extra.price!)!.toInt();
          print(price);
        }
      });
    }
    if (empController.text == "") {
      setState(() {
        onSelect = false;
      });
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus) {
          focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.PRIMARY_BLUE,
        body: Stack(
          children: [
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
              left: 50,
              top: 30,
              child: Container(
                height: height / 6,
                width: width / 7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icons/iconwhite.png"))),
              ),
            ),
            Positioned(
              left: 30,
              top: 50,
              child: MyBackButton(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: height,
                    width: width * 0.6,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Container(
                                        height: height / 10,
                                        width: width * 0.5,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.grey[400]!),
                                          ),
                                        ),
                                        child: Row(children: [
                                          StepBox(
                                            number: 1,
                                            title: 'Collect information',
                                            activeBox: Colors.grey[200]!,
                                            activeText: Colors.grey,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(width: width / 20),
                                          StepBox(
                                            number: 2,
                                            title: 'Select service',
                                            activeBox: Colors.grey[200]!,
                                            activeText: Colors.grey,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(width: width / 20),
                                          StepBox(
                                            number: 3,
                                            title: 'Finalise',
                                            activeBox: Color(0xff20b9f5),
                                            activeText: Colors.white,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: width / 15,
                                child: Text(
                                  'Step 3/3',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: width / 3,
                                child: Text(
                                  'Finalise',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 3.325,
                                      child: Text(
                                        'Choose a staff',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: attendanceBloc.getAttendance,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data == "NOEMPLOYEE") {
                                            return Row(
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: width / 5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: TextFormField(
                                                      enabled: false,
                                                      //textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Colors.grey[500]),
                                                      controller: empController
                                                        ..text =
                                                            "No staffs available",
                                                      decoration:
                                                          InputDecoration(
                                                        // labelText: 'Số điện thoại',
                                                        // labelStyle: TextStyle(fontSize: 20),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 10),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff20b9f5),
                                                              width: 2.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        attendanceBloc
                                                            .getAttendanceBloc(
                                                                context);
                                                        print("Refresh");
                                                        empController
                                                          ..text = "";
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.5)),
                                                        child: Icon(
                                                          Icons.refresh,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            empList =
                                                snapshot.data as List<Employee>;
                                            List<String> temp = [];
                                            for (var data in empList) {
                                              temp.add(data.fullname);
                                            }
                                            return StreamBuilder(
                                                stream: randomBloc.genRandomEmp,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data = snapshot.data
                                                        as Employee;
                                                    return Row(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: width / 5,
                                                          child: TypeAheadField(
                                                            textFieldConfiguration:
                                                                TextFieldConfiguration(
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              autocorrect: true,
                                                              autofocus: false,
                                                              controller: selectEmp
                                                                  ? empController
                                                                  : (empController
                                                                    ..text = data
                                                                        .fullname),
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          10),
                                                                ),
                                                              ),
                                                            ),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    itemData) {
                                                              return ListTile(
                                                                title: Text(
                                                                  itemData
                                                                      as String,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              );
                                                            },
                                                            onSuggestionSelected:
                                                                (suggestion) {
                                                              if (temp.length >
                                                                  1) {
                                                                setState(() {
                                                                  selectEmp =
                                                                      true;
                                                                });
                                                              }
                                                              onSelect = true;
                                                              selectEmp = true;
                                                              empController
                                                                      .text =
                                                                  suggestion
                                                                      as String;
                                                            },
                                                            suggestionsCallback:
                                                                (String
                                                                    pattern) async {
                                                              return AutoCompleteText(
                                                                      temp)
                                                                  .getSuggestions(
                                                                      pattern);
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        buildDice(temp),
                                                      ],
                                                    );
                                                  }
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        height: 60,
                                                        width: width / 5,
                                                        child: TypeAheadField(
                                                          textFieldConfiguration:
                                                              TextFieldConfiguration(
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            autocorrect: true,
                                                            autofocus: false,
                                                            controller:
                                                                empController,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            10),
                                                              ),
                                                            ),
                                                          ),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  itemData) {
                                                            return ListTile(
                                                              title: Text(
                                                                itemData
                                                                    as String,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            );
                                                          },
                                                          onSuggestionSelected:
                                                              (suggestion) {
                                                            if (temp.length >
                                                                1) {
                                                              setState(() {
                                                                selectEmp =
                                                                    true;
                                                              });
                                                            }
                                                            onSelect = true;
                                                            empController.text =
                                                                suggestion
                                                                    as String;
                                                          },
                                                          suggestionsCallback:
                                                              (String
                                                                  pattern) async {
                                                            return AutoCompleteText(
                                                                    temp)
                                                                .getSuggestions(
                                                                    pattern);
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      buildDice(temp),
                                                      buildEstimatedTime(width),
                                                    ],
                                                  );
                                                });
                                          }
                                        } else {
                                          return Container(
                                            height: 60,
                                          );
                                        }
                                      }),
                                ],
                              ),
                              //Spacer(),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 3.325,
                                      child: Text(
                                        'Service',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: width * 0.6,
                                height: 250,
                                child: ListView(
                                  children: [
                                    for (var service in widget.listService)
                                      selectedService(width, service),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                height: 150,
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.grey[400]!),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: width * 0.6,
                                      height: 60,
                                      child: Row(children: [
                                        Text("Total",
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(
                                            "\$" +
                                                MoneyFormat.formatMoney(
                                                    price.toString()),
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                    ),
                                    Container(
                                      height: 89,
                                      width: width * 0.5,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: Colors.grey[400]!),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              height: 60,
                                              child: Container(
                                                width: width / 6,
                                                child: Text(
                                                  'BACK',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          GestureDetector(
                                            onTap: () {
                                              onSignInClicked(context, empList);
                                            },
                                            child: Container(
                                              height: 60,
                                              child: Container(
                                                width: width / 6,
                                                child: Text(
                                                  'FINALISE',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff43ddfb),
                                                        Color(0xff20b9f5),
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildEstimatedTime(width) {
    if (selectEmp) {
      var time = empList
          .where((element) => element.fullname.contains(empController.text))
          .toList()[0]
          .estimatedTime;
      return Container(
        width: 200,
        child: Text(
          'Next Available Time: ' + time!,
          style: TextStyle(fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    } else if (onSelect) {
      var time = empList
          .where((element) => element.fullname.contains(empController.text))
          .toList()[0]
          .estimatedTime;

      return Container(
        width: 200,
        child: Text(
          'Next Available Time: ' + time!,
          style: TextStyle(fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildDice(temp) {
    if (temp.length > 1) {
      return GestureDetector(
        onTap: () {
          randomBloc.getRandomEmpBloc(context);
          setState(() {
            selectEmp = false;
            widget.listService.remove(widget.extra);
          });
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  "assets/icons/dices.png",
                )),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container selectedService(double width, Service service) {
    return Container(
      width: width * 0.5,
      height: 80,
      child: Row(children: [
        SizedBox(width: 10),
        Container(
          width: width / 10,
          height: 65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.fill, image: NetworkImage(service.photo!))),
        ),
        Container(
          width: width / 4.5,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              service.name!,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 70.0),
          child: Text(
            "\$" +
                MoneyFormat.formatMoney(service.price.toString().split(".")[0]),
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
        ),
      ]),
    );
  }

  void onSignInClicked(BuildContext context, List<Employee> temp) {
    FocusScope.of(context).unfocus();
    List<String> result = [];
    String nfc = '';
    String time = '';
    if (empController.text == "") {
      OpenDialog.displayDialog(
          "Error", context, "Please choose a staff", AlertType.error);
    } else {
      nfc = empList
          .where((element) => element.fullname.contains(empController.text))
          .toList()[0]
          .serialNumberNfc;
      time = empList
          .where((element) => element.serialNumberNfc.contains(nfc))
          .toList()[0]
          .estimatedTime!;
      for (var data in widget.listService) {
        result.add(data.serviceVehicleId!);
      }
      this.showDialogConfirmActive();
      bloc.checkInWalkinMemberBloc(
          widget.cust.fullname!,
          nfc,
          widget.cust.plate,
          widget.cust.vehicleBrand,
          widget.cust.phoneNum,
          context,
          result,
          widget.cust.deviceToken!,
          widget.totalPrice.toString(),
          time);
    }

    //}
  }

  void showDialogConfirmActive() {
    showDialog(
        barrierDismissible: false,
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
