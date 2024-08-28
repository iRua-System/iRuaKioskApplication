import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/assignPrice_bloc.dart';
import 'package:kiosk/bloc/getAllServices_bloc.dart';
import 'package:kiosk/bloc/getVehicleType_bloc.dart';

import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/widgets/backButton.dart';

class AssignPrice extends StatefulWidget {
  final List<Service> serviceList;
  final String vehicleType;
  const AssignPrice(
      {required Key key, required this.serviceList, required this.vehicleType})
      : super(key: key);

  @override
  _AssignPriceState createState() => _AssignPriceState();
}

class _AssignPriceState extends State<AssignPrice> {
  GetAllServicesBloc serviceBloc = GetAllServicesBloc();
  GetServicesOfVehicleTypeBloc getBloc = GetServicesOfVehicleTypeBloc();
  @override
  void initState() {
    serviceBloc.getRemainServicesBloc(context, widget.serviceList);
    getBloc.getVehicleTypeBloc(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController priceController = TextEditingController();
  String selectService = '';
  final _formKey = GlobalKey<FormState>();
  List<String> temp = [];
  List<Service> serviceList = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
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
            StreamBuilder(
                stream: getBloc.vehicleType,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    temp = snapshot.data as List<String>;
                  }
                  return Container();
                }),
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
            StreamBuilder(
              stream: serviceBloc.getRemainServices,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Service> list = snapshot.data as List<Service>;
                  if (serviceList.length == 0) {
                    serviceList = list;
                  }

                  if (selectService == '') {
                    selectService = list[0].name!;
                  }
                  print(serviceList.length);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        width: width * 0.6,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, top: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height / 6),
                                  Container(
                                    width: width / 3,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Add service fee",
                                            style: TextStyle(
                                                color: Color(0xff20b9f5),
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    width: width / 2.5,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              "Please choose one of the following services to add a price to the vehicle type." +
                                                  widget.vehicleType
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 3,
                                      child: Text(
                                        'Service ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: width * 0.2,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: DropdownButton<String>(
                                        // iconDisabledColor: Colors.white,
                                        dropdownColor: Colors.white,
                                        underline: SizedBox(),
                                        value: selectService,
                                        items: serviceList.map((e) {
                                          return DropdownMenuItem(
                                            value: e.name,
                                            child: Row(children: <Widget>[
                                              Text(
                                                e.name.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              )
                                            ]),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectService = newValue ?? '';
                                          });
                                        }),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 3,
                                      child: Text(
                                        'Fee',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: width * 0.1,
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 20),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Fee can't be empty";
                                              }

                                              return null;
                                            },
                                            textAlign: TextAlign.right,
                                            controller: priceController..text,
                                            decoration: InputDecoration(
                                              // labelText: 'Số điện thoại',
                                              // labelStyle: TextStyle(fontSize: 20),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff20b9f5),
                                                    width: 2.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Text(
                                        //   ' 000 VNĐ',
                                        //   style: TextStyle(
                                        //     color: Colors.black,
                                        //     fontSize: 20,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    height: 100,
                                    width: width * 0.5,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 1, color: Colors.grey[400]!),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          onSignInClicked(context);
                                        },
                                        child: Container(
                                          height: 60,
                                          child: Container(
                                            width: width / 5,
                                            child: Text(
                                              'UPDATE',
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
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
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 7,
                      backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool onSignInClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    AssignPriceBloc assignBloc = AssignPriceBloc();
    if (this._formKey.currentState!.validate()) {
      var vehicleId = temp
          .where((element) => element.contains(widget.vehicleType))
          .toList()[0]
          .split(".")[0];
      var serviceId = serviceList
          .where((element) => element.name!.contains(selectService))
          .toList()[0]
          .id;
      var price = priceController.text;
      assignBloc
          .assignPriceBloc(context, serviceId!, vehicleId, price)
          .then((value) {
        if (value) {
          setState(() {
            var service = serviceList
                .where((element) => element.name!.contains(selectService))
                .toList()[0];
            serviceList.remove(service);
            selectService = serviceList[0].name!;
          });
        }
      });
    }
    return true;
  }

  void showDialogConfirmActive() {
    showDialog(
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
      },
    );
  }
}
