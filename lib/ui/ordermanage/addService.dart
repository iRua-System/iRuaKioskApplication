import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/addServices_bloc.dart';
import 'package:kiosk/bloc/getServices_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddService extends StatefulWidget {
  final String transactionId;
  final String vehicleId;
  final List<Service> serviceList;
  final ValueChanged<List<Service>> update;
  final ValueChanged? updatePrice;
  final String? status;
  const AddService(
      {Key? key,
      required this.serviceList,
      required this.vehicleId,
      required this.transactionId,
      this.status,
      required this.update,
      this.updatePrice})
      : super(key: key);

  @override
  _AddService createState() => _AddService();
}

class _AddService extends State<AddService> with TickerProviderStateMixin {
  int i = 0;
  int length = 0;
  late List<Service> services;
  GetServicesBloc getBloc = GetServicesBloc();
  AddServicesBloc addBloc = AddServicesBloc();

  @override
  void initState() {
    services = [];
    // TODO: implement initState
    getBloc.getServicesBloc(context, widget.vehicleId, widget.serviceList);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  void update(int price) {
    setState(() {
      i = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    for (var data in widget.serviceList) {
      if (data.name != "Phụ Thu") {
        length++;
      }
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
                Container(
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
                            SizedBox(height: 80),
                            Container(
                              width: width / 3,
                              child: Text(
                                'Thêm Dịch Vụ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 50),
                            StreamBuilder(
                                stream: getBloc.getServices,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data as List<Service>;
                                    if (services.length == 0) {
                                      services = data;
                                    }
                                    return Container(
                                      height: 350,
                                      child: SelectBox(
                                          servicesLength: length,
                                          services: data,
                                          update: update),
                                    );
                                  } else {
                                    return Container(
                                      height: 350,
                                    );
                                  }
                                }),
                            SizedBox(
                              height: height / 20,
                            ),
                            Container(
                              width: width * 0.5,
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.2,
                                    child: Text(
                                      'Tổng cộng',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: width * 0.2,
                                    child: Text(
                                      MoneyFormat.formatMoney(i.toString()) +
                                          ",000 VNĐ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 100,
                              width: width * 0.5,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1, color: Colors.grey[400]!),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                          'QUAY LẠI',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
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
                                      onSignInClicked(context);
                                    },
                                    child: Container(
                                      height: 60,
                                      child: Container(
                                        width: width / 6,
                                        child: Text(
                                          'THÊM DỊCH VỤ',
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
          ])),
    );
  }

  void onSignInClicked(BuildContext context) {
    List<String> result = [];

    bool isNew = false;
    if (widget.status != "Checkin") {
      isNew = true;
    }
    List<Service> addedService = [];
    for (var data in services) {
      if (data.check == true) {
        data.isNew = isNew;
        result.add(data.serviceVehicleId!);
      }
    }
    addBloc
        .addServicesBloc(context, widget.transactionId, result, isNew)
        .then((value) {
      if (value) {
        for (var service in services) {
          if (service.check == true) {
            addedService.add(service);
          }
        }
        widget.update(addedService);
        // Navigator.of(context).pop();
      }
    });
  }
}

class SelectBox extends StatefulWidget {
  final int servicesLength;
  final List<Service> services;
  final ValueChanged<int> update;
  SelectBox({
    Key? key,
    required this.servicesLength,
    required this.update,
    required this.services,
  }) : super(key: key);

  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox>
    with AutomaticKeepAliveClientMixin {
  int i = 0;
  late int selectedService;
  @override
  void initState() {
    selectedService = widget.servicesLength;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (var service in widget.services)
          GestureDetector(
            onTap: () {
              setState(() {
                if (selectedService < 5 &&
                    selectedService != widget.servicesLength) {
                  service.check = !(service.check ?? false);
                  if (service.check!) {
                    selectedService++;
                    updateMoney(widget.services);
                  } else {
                    selectedService--;
                    updateMoney(widget.services);
                  }
                } else if (selectedService == widget.servicesLength) {
                  if (service.check == false) {
                    service.check = true;
                    selectedService++;
                    updateMoney(widget.services);
                  }
                } else if (selectedService == 5) {
                  if (service.check == true) {
                    service.check = false;
                    selectedService--;
                    updateMoney(widget.services);
                  }
                  OpenDialog.displayDialog("Error", context,
                      "Chỉ được sử dụng tối 5 dich vụ", AlertType.error);
                }
              });
            },
            child: Stack(
              children: [
                Container(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                              image: NetworkImage(service.photo!),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 10),
                        child: Text(
                          MoneyFormat.formatMoney(
                                  service.price.toString().split(".")[0]) +
                              ",000 VNĐ",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          service.name!,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(1, 2),
                        color:
                            service.check! ? Colors.green : Color(0x33757575),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 1,
                  child: service.check!
                      ? ClipOval(
                          child: Material(
                            color: Colors.green, // button color
                            child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 50,
                                )),
                          ),
                        )
                      // Icon(
                      //   Icons.check,
                      //   color: Colors.green,
                      //   size: 50,)
                      : Container(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void updateMoney(List<Service> serviceList) {
    int price = 0;
    for (var data in serviceList) {
      if (data.check == true) {
        setState(() {
          price += num.tryParse(data.price!)!.toInt();
        });
      }
    }
    widget.update(price);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
