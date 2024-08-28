import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kiosk/bloc/checkInBookedMember_bloc.dart';
import 'package:kiosk/bloc/checkPlateOnline_bloc.dart';
import 'package:kiosk/bloc/getAttendance_bloc.dart';
import 'package:kiosk/bloc/getExtraFeeByVehicleId_bloc.dart';
import 'package:kiosk/bloc/getRandomEmp_bloc.dart';
import 'package:kiosk/bloc/getVehicleType_bloc.dart';
import 'package:kiosk/bloc/removeServices_bloc.dart';
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/autoComplete.dart';
import 'package:kiosk/models/employee.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/ordermanage/addService.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/helper.dart';
import 'package:kiosk/ui/widgets/service_column.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetBookedInfo extends StatefulWidget {
  final Transaction transaction;

  GetBookedInfo({Key? key, required this.transaction}) : super(key: key);
  @override
  _GetBookedInfo createState() => _GetBookedInfo();
}

class _GetBookedInfo extends State<GetBookedInfo> {
  List<Service> listService = [];
  String totalPrice = '';
  String vehicleBrand = '';
  String vehicleBrandId = '';
  String emp = '';
  bool selectEmp = false;
  GetServicesOfVehicleTypeBloc getServicesBloc = GetServicesOfVehicleTypeBloc();
  GetAttendanceBloc attendanceBloc = GetAttendanceBloc();
  CheckPlateOnlineBloc checkPlateBloc = CheckPlateOnlineBloc();
  GetExtraFeeBloc extraBloc = GetExtraFeeBloc();
  bool onSelect = false;
  @override
  void initState() {
    totalPrice = widget.transaction.price!;
    listService = widget.transaction.services!;
    attendanceBloc.getAttendanceBloc(context);
    extraBloc.getExtraFeeBloc(context, widget.transaction.vehicleId);
    getServicesBloc.getVehicleBrandBloc(
        context, widget.transaction.vehicleName!);

    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  late Service extra;
  CheckInBookedMemberBloc checkinBloc = CheckInBookedMemberBloc();
  TextEditingController reasonController = TextEditingController();
  List<Employee> empList = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bookingDateController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController empController = TextEditingController();
  GetRandomEmpBloc randomBloc = GetRandomEmpBloc();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    if (plateController.text == "") {
      plateController..text = widget.transaction.cust!.vehiclePlate!;
    }
    if (selectEmp) {
      bool check = widget.transaction.services!
              .where((element) => element.name!.contains("Phụ Thu"))
              .toList()
              .length >
          0;
      if (!check) {
        widget.transaction.services!.add(extra);
        updatePrice(widget.transaction.services!);
      }
    } else {
      widget.transaction.services!.remove(extra);
      updatePrice(widget.transaction.services!);
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
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.PRIMARY_BLUE,
          body: Stack(children: [
            // Container(
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: AssetImage("assets/images/wallpaper6.jpg"),
            //             fit: BoxFit.fill))),
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
              left: 30,
              top: 50,
              child: MyBackButton(color: Colors.white),
            ),
            LeftWidget(
              transactionId: widget.transaction.id!,
              width: width,
              height: height,
              services: listService,
              price: totalPrice,
              vehicleId: widget.transaction.vehicleId!,
              update: update,
              updatePrice: updatePrice,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder(
                    stream: extraBloc.getExtraFee,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        extra = snapshot.data as Service;
                      }
                      return Container();
                    }),
                Container(
                  height: height,
                  width: width / 2,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50, left: 50),
                        width: width / 2,
                        child: Text(
                          'Booked information',
                          style: TextStyle(
                              color: Color(0xff1fa2ff),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Container(
                          width: width / 2,
                          child: Text(
                            'Fullname',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Container(
                            color: Colors.grey[200],
                            height: 60,
                            width: width * 0.355,
                            child: TextFormField(
                              enabled: false,
                              style: TextStyle(fontSize: 20),
                              //textAlign: TextAlign.right,
                              controller: nameController
                                ..text = widget.transaction.cust!.fullname!,
                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                // labelText: 'Số điện thoại',
                                // labelStyle: TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 10),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 6,
                                      child: Text(
                                        'Phone number',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey[200],
                                    height: 60,
                                    width: width / 7,
                                    child: TextFormField(
                                      enabled: false,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 20),
                                      controller: phoneController
                                        ..text =
                                            widget.transaction.cust!.phoneNum!,
                                      decoration: InputDecoration(
                                        // labelText: 'Số điện thoại',
                                        // labelStyle: TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 6,
                                      child: Text(
                                        'Booked time',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      color: Colors.grey[200],
                                      height: 60,
                                      width: width / 6,
                                      child: TextFormField(
                                        enabled: false,
                                        textAlign: TextAlign.right,
                                        controller: bookingDateController
                                          ..text =
                                              widget.transaction.bookingDate!,
                                        style: TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                          // labelText: 'Số điện thoại',
                                          // labelStyle: TextStyle(fontSize: 20),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 10),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 7,
                                      child: Text(
                                        'Vehicle Type',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: width / 7,
                                    color: Colors.grey[200],
                                    child: TextFormField(
                                      enabled: false,
                                      //textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 20),
                                      controller: vehicleTypeController
                                        ..text =
                                            widget.transaction.vehicleName!,
                                      decoration: InputDecoration(
                                        // labelText: 'Số điện thoại',
                                        // labelStyle: TextStyle(fontSize: 20),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              StreamBuilder(
                                  stream: getServicesBloc.vehicleBrand,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<String> temp =
                                          snapshot.data as List<String>;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 6,
                                              child: Text(
                                                'Vehicle Brand',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            width: width / 6,
                                            child: TypeAheadField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                style: TextStyle(fontSize: 20),
                                                autocorrect: true,
                                                autofocus: false,
                                                controller: brandController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 10),
                                                  ),
                                                ),
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      itemData) {
                                                return ListTile(
                                                  title: Text(
                                                      itemData as String,
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                brandController.text =
                                                    suggestion as String;
                                                vehicleBrand = suggestion;
                                              },
                                              suggestionsCallback:
                                                  (String pattern) async {
                                                return AutoCompleteText(temp)
                                                    .getSuggestions(pattern);
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: width * 0.46,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 6,
                                      child: Text(
                                        'Plate',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: width / 7,
                                    child: TextFormField(
                                      maxLength: 10,
                                      validator: (value) {
                                        RegExp regExp = new RegExp(
                                            RegexConstants.NZPLATEREGEX);
                                        if (value!.trim().isEmpty) {
                                          return "Plate can't be empty";
                                        }
                                        if (!regExp.hasMatch(value)) {
                                          return "Plate is invalid";
                                        }
                                        return null;
                                      },
                                      //enabled: false,
                                      //textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 20),
                                      controller: plateController,
                                      decoration: InputDecoration(
                                        counterText: "",
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
                                ],
                              ),
                              Spacer(),
                              StreamBuilder(
                                stream: attendanceBloc.getAttendance,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    empList = snapshot.data as List<Employee>;
                                    List<String> temp = [];
                                    for (var data in empList) {
                                      temp.add(data.fullname);
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: width / 6,
                                            child: Text(
                                              'Staff',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            StreamBuilder(
                                              stream: randomBloc.genRandomEmp,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var data =
                                                      snapshot.data as Employee;
                                                  return Container(
                                                    height: 60,
                                                    width: width / 6,
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 10),
                                                          ),
                                                        ),
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              itemData) {
                                                        return ListTile(
                                                          title: Text(
                                                            itemData as String,
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) {
                                                        if (temp.length > 1) {
                                                          setState(() {
                                                            selectEmp = true;
                                                          });
                                                        }
                                                        onSelect = false;
                                                        selectEmp = true;
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
                                                  );
                                                } else {
                                                  return Container(
                                                    height: 60,
                                                    width: width / 6,
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
                                                                    width: 10),
                                                          ),
                                                        ),
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              itemData) {
                                                        return ListTile(
                                                          title: Text(
                                                            itemData as String,
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) {
                                                        if (temp.length > 1) {
                                                          setState(() {
                                                            selectEmp = true;
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
                                                  );
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            buildDice(temp),
                                            buildEstimatedTime(width),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            finishButton(
                                context, width, widget.transaction.status!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ])),
    );
  }

  buildEstimatedTime(width) {
    if (selectEmp) {
      var time = empList
          .where((element) => element.fullname.contains(empController.text))
          .toList()[0]
          .estimatedTime;

      return Center(
        child: Text(
          time!,
          style: TextStyle(fontSize: 23, color: Colors.black.withOpacity(0.5)),
          textAlign: TextAlign.center,
        ),
      );
    } else if (onSelect) {
      var time = empList
          .where((element) => element.fullname.contains(empController.text))
          .toList()[0]
          .estimatedTime;

      return Center(
        child: Text(
          time!,
          style: TextStyle(fontSize: 23, color: Colors.black.withOpacity(0.5)),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container();
    }
  }

  GestureDetector finishButton(
      BuildContext context, double width, String transStatus) {
    if (transStatus != "Checkin") {
      return GestureDetector(
        onTap: () {
          onFinishClicked(context);
        },
        child: Container(
          height: 60,
          width: width / 7,
          child: Container(
            width: width / 10,
            child: Text(
              'CHECK IN',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff43ddfb),
                    Color(0xff20b9f5),
                  ]),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(child: Container());
    }
  }

  void onFinishClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    String vehiclePlate = plateController.text;
    String nfc = '';
    if (empController.text == "") {
      OpenDialog.displayDialog(
          "Error", context, "Please choose a staff", AlertType.error);
    } else {
      nfc = empList
          .where((element) => element.fullname.contains(empController.text))
          .toList()[0]
          .serialNumberNfc;
      this.showDialogConfirmActive();
      checkPlateBloc.checkPlateOnlineBloc(
          context, vehiclePlate, widget.transaction.id!, nfc, vehicleBrand);
    }

    // checkinBloc.checkInBookedMemberBloc(
    //     context, widget.transaction.id, "RANDOM", vehiclePlate, vehicleBrand);
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

  void update(List<Service> addedServices) {
    setState(() {
      listService.addAll(addedServices);
      int i = 0;
      for (var service in listService) {
        i += num.tryParse(service.price!)!.toInt();
      }
      totalPrice = i.toString();
    });
  }

  void updatePrice(List<Service> temps) {
    setState(() {
      int i = 0;
      for (var service in temps) {
        i += num.tryParse(service.price!)!.toInt();
      }
      totalPrice = i.toString();
    });
  }

  Widget buildDice(temp) {
    if (temp.length > 1) {
      return GestureDetector(
        onTap: () {
          randomBloc.getRandomEmpBloc(context);
          setState(() {
            selectEmp = false;
            // if (extra != null) {
            //   widget.transaction.services.remove(extra);
            // }
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
      return Container(
        height: 60,
        width: 60,
      );
    }
  }
}

class LeftWidget extends StatefulWidget {
  const LeftWidget(
      {Key? key,
      required this.width,
      required this.update,
      required this.transactionId,
      required this.height,
      required this.services,
      required this.vehicleId,
      required this.price,
      required this.updatePrice})
      : super(key: key);
  final String transactionId;
  final String vehicleId;
  final double width;
  final double height;
  final List<Service> services;
  final String price;
  final ValueChanged<List<Service>> update;
  final ValueChanged<List<Service>> updatePrice;
  @override
  _LeftWidgetState createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  RemoveServicesBloc bloc = RemoveServicesBloc();

  @override
  void initState() {
    print(widget.services.length);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      width: widget.width / 2,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, left: 50),
            width: widget.width / 2,
            child: Text(
              'Dịch vụ đã chọn',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          IconButton(
              color: Colors.white,
              iconSize: 40,
              icon: Icon(Icons.add),
              onPressed: () {
                if (widget.services.length == 5) {
                  OpenDialog.displayDialog("Error", context,
                      "Chỉ được sử dụng tối 5 dich vụ", AlertType.error);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddService(
                          serviceList: widget.services,
                          vehicleId: widget.vehicleId,
                          transactionId: widget.transactionId,
                          update: widget.update)));
                }
              }),
          Container(
            height: widget.height - 700,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < widget.services.length; i++)
                    ServiceColumn(
                      title: widget.services[i].name!,
                      price: widget.services[i].price!.split(".")[0],
                      icon: Icon(Icons.clear),
                      status: "Checkin",
                      onPressedIcon: () {
                        onRemoveClicked(context, widget.services[i]);
                      },
                    ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, color: Colors.grey[800]!),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Text("Tổng cộng",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Spacer(),
                  Text(MoneyFormat.formatMoney(widget.price) + ",000 VND",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  onRemoveClicked(
    context,
    Service service,
  ) async {
    if (widget.services.length == 1) {
      OpenDialog.displayDialog("Error", context,
          "Mỗi đơn hàng phải tồn tại ít nhất 1 dịch vụ", AlertType.error);
    } else {
      bool check = await bloc.removeServicesBloc(
          context, widget.transactionId, service.serviceVehicleId!);
      if (check) {
        setState(() {
          widget.services.remove(service);
          widget.updatePrice(widget.services);
        });
      }
    }
  }
}
