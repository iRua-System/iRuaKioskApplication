import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:kiosk/bloc/cancelTransaction_bloc.dart';
import 'package:kiosk/bloc/checkAdmin_bloc.dart';
import 'package:kiosk/bloc/finishTransaction_bloc.dart';
import 'package:kiosk/bloc/getPayment_bloc.dart';
import 'package:kiosk/bloc/removeServices_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/payment.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/ordermanage/addService.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/helper.dart';
import 'package:kiosk/ui/widgets/service_column.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ManageTransactions extends StatefulWidget {
  final String phoneNum;
  final Transaction transaction;

  ManageTransactions(
      {Key? key, required this.transaction, required this.phoneNum})
      : super(key: key);
  @override
  _ManageTransactions createState() => _ManageTransactions();
}

class _ManageTransactions extends State<ManageTransactions> {
  List<Service> listService = [];
  String totalPrice = '';
  late bool customerCanceled;
  String payment = '';
  String paymentId = '';

  List<Payment> temp = [];
  GetPaymentBloc payBloc = GetPaymentBloc();
  @override
  void initState() {
    totalPrice = widget.transaction.price!;
    listService = widget.transaction.services!;
    payBloc.getPaymentBloc(context);
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CancelTransactionBloc cancelBloc = CancelTransactionBloc();
  TextEditingController reasonController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController brandController = TextEditingController();
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
        key: _scaffoldKey,
        body: Stack(
          children: [
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
                status: widget.transaction.status!,
                update: update),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                          'Thông tin ',
                          style: TextStyle(
                              color: Colors.black,
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
                            'Họ và tên',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 50),
                          height: 60,
                          width: width * 0.4,
                          child: TextFormField(
                            enabled: false,
                            style: TextStyle(fontSize: 20),
                            //textAlign: TextAlign.right,
                            controller: nameController
                              ..text = widget.transaction.cust!.fullname!,
                            decoration: InputDecoration(
                              // labelText: 'Số điện thoại',
                              // labelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff20b9f5), width: 2.0),
                              ),
                            ),
                          )),
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
                                        'Số điện thoại',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 7,
                                      child: Text(
                                        'Biển số xe',
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
                                      child: TextFormField(
                                        enabled: false,
                                        //textAlign: TextAlign.right,
                                        controller: plateController
                                          ..text =
                                              widget.transaction.vehiclePlate!,
                                        style: TextStyle(fontSize: 20),
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
                                      width: width / 6,
                                      child: Text(
                                        'Loại xe',
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
                                      enabled: false,
                                      textAlign: TextAlign.right,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      width: width / 7,
                                      child: Text(
                                        'Hãng xe',
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
                                      child: TextFormField(
                                        enabled: false,
                                        //textAlign: TextAlign.right,
                                        controller: brandController
                                          ..text =
                                              widget.transaction.vehicleBrand!,
                                        style: TextStyle(fontSize: 20),
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
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildPayment(width),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCancel(width, widget.transaction.status),
                            SizedBox(width: 10),
                            finishButton(
                                context, width, widget.transaction.status!),
                            SizedBox(width: 10),
                            finishWithoutPaymentButton(
                                context, width, widget.transaction.status!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildCancel(double width, status) {
    if (status == "Checkin") {
      return GestureDetector(
        onTap: () {
          openRatingBox();
        },
        child: Container(
          height: 60,
          width: width / 7,
          child: Container(
            width: width / 7,
            child: Text(
              'HUỶ ĐƠN',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildPayment(double width) {
    if (widget.transaction.status != "Checkin") {
      if (widget.transaction.cust!.cusId!.split("-")[0] != "00000000") {
        return StreamBuilder(
            stream: payBloc.getPayment,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != "NOPAYMENT") {
                temp = snapshot.data as List<Payment>;
                List<Payment> list = [];
                for (var data in temp) {
                  if (data.paymentType != "Chưa Thanh Toán") {
                    list.add(data);
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 50.0, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: width / 5,
                          child: Text(
                            'Phương thức thanh toán',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectPayment(list);
                        },
                        child: Container(
                          height: 70,
                          width: width / 7,
                          child: AbsorbPointer(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Vui lòng chọn loại xe";
                                }
                                return null;
                              },
                              //textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 20),
                              controller: paymentController..text = payment,
                              decoration: InputDecoration(
                                // labelText: 'Số điện thoại',
                                // labelStyle: TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff20b9f5), width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            });
      } else {
        return StreamBuilder(
            stream: payBloc.getPayment,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != "NOPAYMENT") {
                temp = snapshot.data as List<Payment>;
                List<Payment> list = [];
                for (var data in temp) {
                  if (data.paymentType != "Chưa Thanh Toán" &&
                      data.paymentType != "E-wallet") {
                    list.add(data);
                  }
                }
                if (list.length == 1) {
                  payment = list[0].paymentType!;
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 50.0, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: width / 5,
                          child: Text(
                            'Phương thức thanh toán',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectPayment(list);
                        },
                        child: Container(
                          height: 70,
                          width: width / 7,
                          child: AbsorbPointer(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Vui lòng chọn loại xe";
                                }
                                return null;
                              },
                              //textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 20),
                              controller: paymentController..text = payment,
                              decoration: InputDecoration(
                                // labelText: 'Số điện thoại',
                                // labelStyle: TextStyle(fontSize: 20),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff20b9f5), width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            });
      }
    } else {
      return Container();
    }
  }

  selectPayment(list) async {
    List<String> temp = [];
    for (var data in list) {
      temp.add(data.paymentType);
    }
    Picker picker = Picker(
        height: 300,
        adapter: PickerDataAdapter<String>(pickerData: temp),
        onConfirm: (Picker picker, List value) {
          setState(() {
            payment = picker
                .getSelectedValues()
                .toString()
                .split("[")[1]
                .split("]")[0];
          });
        });
    picker.show(_scaffoldKey.currentState!);
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
              'HOÀN THÀNH',
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

  GestureDetector finishWithoutPaymentButton(
      BuildContext context, double width, String transStatus) {
    if (transStatus != "Checkin") {
      return GestureDetector(
        onTap: () {
          onFinishWithoutPaymentClicked(context);
        },
        child: Container(
          height: 60,
          width: width / 7,
          child: Container(
            width: width / 10,
            child: Text(
              'BLACKLIST',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
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
    var pay = temp
        .where((element) => element.paymentType!.contains(payment))
        .toList();
    var payId = pay[0].id;
    if (payId != null || payment != null) {
      PasswordDialog.displayDialog(context, widget.transaction.id, payId,
          payment, widget.transaction.cust!.deviceToken);
    } else {
      OpenDialog.displayDialog("Error", context,
          "Vui lòng chọn phương thức thanh toán đơn hàng", AlertType.error);
    }
  }

  void onFinishWithoutPaymentClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    var pay = temp
        .where((element) => element.paymentType!.contains("Chưa Thanh Toán"))
        .toList();
    var payId = pay[0].id;
    PasswordDialog.displayDialog(context, widget.transaction.id, payId,
        pay[0].paymentType, widget.transaction.cust!.deviceToken);
  }

  void update(List<Service> addedServices) {
    setState(() {
      listService.addAll(addedServices);
    });
  }

  openRatingBox() {
    customerCanceled = false;
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0))),
              contentPadding: EdgeInsets.only(top: 20.0),
              content: Container(
                width: 500.0,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 30.0),
                          child: Text(
                            "Người Hủy : ",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: customerCanceled,
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  customerCanceled = value as bool;
                                });
                              },
                            ),
                            Text(
                              'Khách hàng',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 30.0),
                      child: Text(
                        "Lí do Hủy ",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Container(
                      height: 241,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFormField(
                          controller: reasonController,
                          style: TextStyle(fontSize: 25),
                          decoration: InputDecoration(
                            hintText: "Lí do hủy đơn",
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onCancelClicked(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                              bottomRight: Radius.circular(32.0)),
                        ),
                        child: Text(
                          "HỦY ĐƠN",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void onCancelClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    String actor = '';
    if (customerCanceled) {
      actor = widget.transaction.cust!.cusId!;
    } else {
      actor = widget.transaction.emp!.empId;
    }
    print(widget.transaction.cust!.cusId!);
    print(actor);
    this.showDialogConfirmActive();
    //finishBloc.finishTransactionBloc(context, "1", widget.transaction.id);
    cancelBloc.cancelTransactionBloc(context, widget.transaction.id!,
        reasonController.text, actor, widget.transaction.cust!.deviceToken);
    print("Huỷ nè");
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

class LeftWidget extends StatefulWidget {
  const LeftWidget({
    Key? key,
    required this.width,
    required this.status,
    required this.update,
    required this.transactionId,
    required this.height,
    required this.services,
    required this.vehicleId,
    required this.price,
  }) : super(key: key);
  final String transactionId;
  final String vehicleId;
  final double width;
  final double height;
  final List<Service> services;
  final String price;
  final ValueChanged<List<Service>> update;
  final String status;
  @override
  _LeftWidgetState createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  RemoveServicesBloc bloc = RemoveServicesBloc();
  int i = 0;
  int length = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var data in widget.services) {
      i = i + num.tryParse(data.price!)!.toInt();
    }
    widget.services
        .sort((a, b) => b.name != "Phụ Thu" && !(b.isNew ?? false) ? 1 : -1);
  }

  @override
  Widget build(BuildContext context) {
    for (var data in widget.services) {
      if (data.name != "Phụ Thu") {
        length++;
      }
    }
    //widget.services.sort((a, b) => b.isNew ? -1 : 1);

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
                if (length == 5) {
                  OpenDialog.displayDialog("Error", context,
                      "Chỉ được sử dụng tối 5 dich vụ", AlertType.error);
                } else {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => AddService(
                          serviceList: widget.services,
                          vehicleId: widget.vehicleId,
                          transactionId: widget.transactionId,
                          status: widget.status,
                          update: widget.update),
                    ),
                  )
                      .then((value) {
                    setState(() {
                      i = 0;
                      for (var data in widget.services) {
                        i = i + num.tryParse(data.price!)!.toInt();
                      }
                    });
                  });
                }
              }),
          Container(
            height: widget.height - 630,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var data in widget.services)
                    ServiceColumn(
                      title: data.name!,
                      price: data.price!,
                      icon: Icon(Icons.clear),
                      isNew: data.isNew,
                      status: widget.status,
                      onPressedIcon: () {
                        onRemoveClicked(context, data);
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
                  Text("\$" + MoneyFormat.formatMoney(i.toString()),
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

  onRemoveClicked(
    context,
    Service service,
  ) async {
    if (widget.services.length == 1) {
      OpenDialog.displayDialog("Error", context,
          "Mỗi đơn hàng phải tồn tại ít nhất 1 dịch vụ", AlertType.error);
    } else {
      this.showDialogConfirmActive();
      bool check = await bloc.removeServicesBloc(
          context, widget.transactionId, service.serviceVehicleId!);
      if (check) {
        setState(() {
          widget.services.remove(service);
          i = 0;
          for (var data in widget.services) {
            i = i + num.tryParse(data.price!)!.toInt();
          }
        });
      }
    }
  }
}

class PasswordDialog {
  static void showDialogConfirmActive(context) {
    showDialog(
        context: context,
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

  static void displayDialog(context, transId, paymentId, payment, deviceToken) {
    FinishTransactionBloc finishBloc = FinishTransactionBloc();
    TextEditingController passwordController = TextEditingController();
    var alertStyle = AlertStyle(
      overlayColor: Colors.black.withOpacity(0.3),
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
        title: "Nhập mật khẩu",
        content: Column(
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              showDialogConfirmActive(context);
              if (passwordController.text.trim().isEmpty) {
                OpenDialog.displayDialog(
                    "Error", context, "Mật khẩu không hợp lệ", AlertType.error);
              } else {
                CheckAdminBloc checkBloc = CheckAdminBloc();
                String password = passwordController.text;
                checkBloc.checkAdminBloc(context, password).then((value) {
                  if (value) {
                    finishBloc.finishTransactionBloc(
                        context, paymentId, payment, transId, deviceToken);
                  } else {
                    Navigator.of(context).pop();
                    OpenDialog.displayDialog("Error", context,
                        "Mật khẩu không đúng ", AlertType.error);
                  }
                });
              }
            },
            child: Text(
              "Đăng Nhập",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
