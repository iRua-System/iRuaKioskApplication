import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/booking/member/unbooked/getWalkinCheck.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/helper.dart';
import 'package:kiosk/ui/widgets/stepBox.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetWalkinService extends StatefulWidget {
  final Customer cust;
  final String vehicleType;
  final List<Service> serviceList;
  const GetWalkinService(
      {Key? key,
      required this.cust,
      required this.vehicleType,
      required this.serviceList})
      : super(key: key);

  @override
  _GetWalkinService createState() => _GetWalkinService();
}

class _GetWalkinService extends State<GetWalkinService>
    with TickerProviderStateMixin {
  int i = 0;
  late List<Service> serviceList;
  late Service extra;
  String search = "";
  TextEditingController searchController = TextEditingController();
  List<Service> filterService = [];
  @override
  void initState() {
    serviceList = [];
    String wash = "Rửa Xe";
    for (var data in widget.serviceList) {
      if (data.vehicleName == widget.vehicleType) {
        if (data.name!.compareTo(wash) == 0) {
          data.check = true;
          i += num.tryParse(data.price.toString())!.toInt();
        } else if (data.check == true) {
          i += num.tryParse(data.price.toString())!.toInt();
        }
        serviceList.add(data);
      }

      if (data.name == "Phụ Thu") {
        if (data.vehicleName == widget.vehicleType) {
          extra = data;
        }

        serviceList.remove(data);
      }
    }

    // TODO: implement initState
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
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(width: width / 20),
                                        StepBox(
                                          number: 2,
                                          title: 'Select service',
                                          activeBox: Color(0xff20b9f5),
                                          activeText: Colors.white,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: width / 20),
                                        StepBox(
                                          number: 3,
                                          title: 'Finalise',
                                          activeBox: Colors.grey[200]!,
                                          activeText: Colors.grey,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ]),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: width / 15,
                              child: Text(
                                'Step 2/3',
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
                                'Service',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: width / 10,
                                  child: Text(
                                    'Service name',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    width: width * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          search = value;
                                          filterService.clear();
                                          filterService = serviceList
                                              .where((element) =>
                                                  element.name!.contains(value))
                                              .toList();
                                          print(filterService.length);
                                        });
                                      },
                                      style: TextStyle(fontSize: 20),
                                      controller: searchController,
                                      decoration: InputDecoration(
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
                                    )),
                                SizedBox(width: 10),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 330,
                              child: SelectBox(
                                services:
                                    (filterService.length >= 0 && search != "")
                                        ? filterService
                                        : serviceList,
                                update: update,
                                allServices: serviceList,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: width * 0.5,
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.2,
                                    child: Text(
                                      'Total',
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
                                      "\$" +
                                          MoneyFormat.formatMoney(i.toString()),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
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
                                          'BACK',
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
                                          'NEXT',
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
    List<Service> result = [];
    for (var data in serviceList) {
      if (data.check == true) {
        result.add(data);
      }
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GetWalkinCheck(
              cust: widget.cust,
              listService: result,
              totalPrice: i,
              extra: extra,
            )));
  }
}

class SelectBox extends StatefulWidget {
  final List<Service> services;
  final List<Service> allServices;
  final ValueChanged<int> update;
  SelectBox(
      {Key? key,
      required this.update,
      required this.services,
      required this.allServices})
      : super(key: key);

  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox>
    with AutomaticKeepAliveClientMixin {
  int i = 0;
  @override
  void initState() {
    for (var data in widget.services) {
      if (data.check!) {
        i++;
      }
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.services.sort((a, b) => b.check! && b.name == "Rửa Xe" ? 1 : -1);
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (var service in widget.services)
          GestureDetector(
            onTap: () {
              setState(() {
                if (i > 1 && i < 5) {
                  Service temp = widget.allServices
                      .where((element) => element.name!.contains(service.name!))
                      .toList()[0];
                  service.check = !(service.check ?? false);
                  temp.check = service.check;
                  if (service.check == false) {
                    i--;
                  } else {
                    i++;
                  }
                  updateMoney(widget.allServices);
                } else if (i == 1) {
                  if (service.check == false) {
                    i++;
                  }
                  Service temp = widget.allServices
                      .where((element) => element.name!.contains(service.name!))
                      .toList()[0];
                  temp.check = true;
                  service.check = true;
                  updateMoney(widget.allServices);
                  if (service.check! && i == 1) {
                    OpenDialog.displayDialog(
                        "Error",
                        context,
                        "At least one service must be selected.",
                        AlertType.error);
                  }
                } else if (i == 5) {
                  if (service.check == true) {
                    i--;
                  }

                  if (service.check == false) {
                    OpenDialog.displayDialog(
                        "Error",
                        context,
                        "A maximum of 5 services can be selected.",
                        AlertType.error);
                  }
                  Service temp = widget.allServices
                      .where((element) => element.name!.contains(service.name!))
                      .toList()[0];
                  temp.check = false;
                  service.check = false;
                  updateMoney(widget.allServices);
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
                        height: 160,
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
                          "\$" +
                              MoneyFormat.formatMoney(
                                  service.price.toString().split(".")[0]),
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
                        color: service.check == true
                            ? Colors.green
                            : Color(0x33757575),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 1,
                  child: service.check == true
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
