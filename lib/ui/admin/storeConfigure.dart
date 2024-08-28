import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/bloc/changeSafeKey_bloc.dart';
import 'package:kiosk/bloc/checkAdmin_bloc.dart';
import 'package:kiosk/bloc/getStoreConfigure_bloc.dart';
import 'package:kiosk/bloc/updateStoreConfigure_bloc.dart';
import 'package:kiosk/constants/api.dart';

import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/store.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StoreConfigure extends StatefulWidget {
  @override
  _StoreConfigure createState() => _StoreConfigure();
}

class _StoreConfigure extends State<StoreConfigure> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  GetConfigureBloc getBloc = GetConfigureBloc();
  @override
  void initState() {
    getBloc.getConfigureBloc(context);

    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController storeNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bikeController = TextEditingController();
  TextEditingController carController = TextEditingController();
  UpdateStoreConfigureBloc updateBloc = UpdateStoreConfigureBloc();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController openController = TextEditingController();
  TextEditingController closeController = TextEditingController();
  late DateTime open;
  late DateTime close;
  final _formKey = GlobalKey<FormState>();
  bool newImage = false;
  MyFile img = MyFile();
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
            stream: getBloc.getConfigure,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != "NOSTORE") {
                Store store = snapshot.data as Store;
                print(store);
                if (storeNameController.text == "") {
                  storeNameController..text = store.storeName!;
                }
                if (ownerNameController.text == "") {
                  ownerNameController..text = store.ownerName!;
                }
                if (phoneController.text == "") {
                  phoneController..text = store.phone!;
                }
                if (addressController.text == "") {
                  addressController..text = store.address!;
                }
                open = DateTime.parse("1970-01-01 " + store.openTime!);
                close = DateTime.parse("1970-01-01 " + store.closeTime!);
                String openMinute = open.minute.toString();
                String closeMinute = close.minute.toString();
                if (openMinute.length == 1) {
                  openMinute = "0" + openMinute;
                }
                if (closeMinute.length == 1) {
                  closeMinute = "0" + closeMinute;
                }
                if (openController.text == "") {
                  openController
                    ..text = open.hour.toString() + ":" + openMinute;
                }
                if (closeController.text == "") {
                  closeController
                    ..text = close.hour.toString() + ":" + closeMinute;
                }
                return Stack(
                  children: [
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
                                print("test");
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
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: width * 0.87,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: height,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 50.0, left: 150),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width / 3,
                                      child: Text(
                                        'Store information',
                                        style: TextStyle(
                                            color: Color(0xff1fa2ff),
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                ImagePicker picker =
                                                    ImagePicker();
                                                picker
                                                    .pickImage(
                                                        source:
                                                            ImageSource.gallery)
                                                    .then((value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      img.file = value as File?;
                                                      img.url = value.path;
                                                      newImage = true;
                                                    });
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: 200,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: img.file == null
                                                            ? NetworkImage(store
                                                                    .ownerImage!)
                                                                as ImageProvider
                                                            : FileImage(
                                                                img.file!))),
                                              ),
                                            ),
                                            SizedBox(width: 30),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Owner name ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '(*)',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  height: 70,
                                                  width: width / 3.3,
                                                  child: TextFormField(
                                                    maxLength: 100,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Name can't be empty";
                                                      }

                                                      return null;
                                                    },
                                                    //enabled: edit ? true : false,
                                                    //textAlign: TextAlign.right,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    controller:
                                                        ownerNameController,
                                                    decoration: InputDecoration(
                                                      counterText: "",
                                                      // labelText: 'Số điện thoại',
                                                      // labelStyle: TextStyle(fontSize: 20),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
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
                                                Container(
                                                  width: width / 3.3,
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Start ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                '(*)',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          GestureDetector(
                                                            onTap: () {
                                                              _showOpenDatePicker(
                                                                  context,
                                                                  open);
                                                            },
                                                            child: Container(
                                                              height: 70,
                                                              width: width / 7,
                                                              child:
                                                                  TextFormField(
                                                                enabled: false,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                                controller:
                                                                    openController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  counterText:
                                                                      "",
                                                                  // labelText: 'Số điện thoại',
                                                                  // labelStyle: TextStyle(fontSize: 20),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            10),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff20b9f5),
                                                                        width:
                                                                            2.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'End ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                '(*)',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          GestureDetector(
                                                            onTap: () {
                                                              _showCloseDatePicker(
                                                                  context,
                                                                  close,
                                                                  open);
                                                            },
                                                            child: Container(
                                                              height: 70,
                                                              width: width / 7,
                                                              child:
                                                                  TextFormField(
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                enabled: false,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                                controller:
                                                                    closeController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  counterText:
                                                                      "",
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            10),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff20b9f5),
                                                                        width:
                                                                            2.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: width / 3,
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Store name ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '(*)',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          width: width * 0.5,
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 20),
                                            maxLength: 100,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Name can't be empty";
                                              }
                                              if (value.length < 10) {
                                                return "Name can't be less than 10 characters";
                                              }
                                              return null;
                                            },
                                            //enabled: edit ? true : false,
                                            //textAlign: TextAlign.right,
                                            controller: storeNameController,
                                            // onChanged: (value) =>{
                                            //   storeNameController.text = value
                                            // },
                                            decoration: InputDecoration(
                                              counterText: "",
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Container(
                                                    width: width / 3.325,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Phone Number ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '(*)',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 70,
                                                  width: width / 5,
                                                  child: TextFormField(
                                                    maxLength: 10,
                                                    validator: (value) {
                                                      RegExp regExp = new RegExp(
                                                          RegexConstants
                                                              .NZPHONEREGEX);
                                                      if (value!.isEmpty) {
                                                        return "Phone number can't be empty";
                                                      }
                                                      if (!regExp
                                                          .hasMatch(value)) {
                                                        return "Phone number isn't valid";
                                                      }
                                                      return null;
                                                    },
                                                    //enabled: edit ? true : false,
                                                    textAlign: TextAlign.right,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    controller: phoneController,
                                                    decoration: InputDecoration(
                                                      counterText: "",
                                                      // labelText: 'Số điện thoại',
                                                      // labelStyle: TextStyle(fontSize: 20),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
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
                                              ],
                                            ),
                                            //Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Container(
                                                    width: width / 5,
                                                    child: Text(
                                                      'Safe Key : ',
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
                                                    PasswordDialog
                                                        .displayDialog(context);
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    width: width / 5,
                                                    child: Text(
                                                      'CHANGE SAFE KEY',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20),
                                                    ),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1fa2ff),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: width / 3,
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Address ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '(*)',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 100,
                                          width: width * 0.5,
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 20),
                                            maxLength: 100,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Address can't be empty";
                                              }
                                              if (value.length < 10) {
                                                return "Address can't be less than 10 characters";
                                              }
                                              return null;
                                            },
                                            //textAlign: TextAlign.right,
                                            //enabled: edit ? true : false,
                                            controller: addressController,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              counterText: "",
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
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            buildButton(width, store),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
            }),
      ),
    );
  }

  buildButton(double width, Store store) {
    if (!isDrawerOpen) {
      return StreamBuilder(
          stream: updateBloc.isChecking,
          builder: (context, snapshot) {
            if (snapshot.data == "Checking") {
              return Container(
                height: 60,
                width: width / 5,
                child: CircularProgressIndicator(
                  strokeWidth: 7,
                  backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff1fa2ff),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  onUpdateClicked(context, store);
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
            }
          });
    } else {
      return StreamBuilder(
          stream: updateBloc.isChecking,
          builder: (context, snapshot) {
            if (snapshot.data == "Checking") {
              return Container(
                height: 60,
                width: width / 5,
                child: CircularProgressIndicator(
                  strokeWidth: 7,
                  backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff1fa2ff),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            } else {
              return Container(
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
              );
            }
          });
    }
  }

  _showOpenDatePicker(context, time) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 500,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Container(
              height: 400,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: time,
                  use24hFormat: true,
                  onDateTimeChanged: (val) {
                    String min = val.minute.toString();
                    if (val.minute.toString().length == 1) {
                      min = "0" + val.minute.toString();
                    }
                    setState(() {
                      open = val;
                      openController..text = val.hour.toString() + ":" + min;
                    });
                  }),
            ),

            // Close the modal
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  _showCloseDatePicker(context, time, open) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 500,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Container(
              height: 400,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: time,
                  use24hFormat: true,
                  onDateTimeChanged: (val) {
                    String min = val.minute.toString();
                    if (val.minute.toString().length == 1) {
                      min = "0" + val.minute.toString();
                    }
                    setState(() {
                      close = val;
                      closeController
                        ..text = val.hour.toString() + ":" + min.toString();
                    });
                  }),
            ),

            // Close the modal
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                if (close.isBefore(open) || close.isAtSameMomentAs(open)) {
                  OpenDialog.displayDialog(
                      "Error",
                      context,
                      "The end time must be later than the start time.",
                      AlertType.error);
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void onUpdateClicked(BuildContext context, Store oldStore) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      String storeName = storeNameController.text;
      String phone = phoneController.text;
      String address = addressController.text;

      Store store = Store(
          storeName: storeName,
          phone: phone,
          address: address,
          numOfMotorbike: oldStore.numOfMotorbike,
          numOfCar: oldStore.numOfCar,
          ownerName: oldStore.ownerName,
          openTime: openController.text,
          closeTime: closeController.text,
          ownerImage: oldStore.ownerImage);

      updateBloc
          .updateStoreConfigureBloc(context, store, newImage, img)
          .then((value) {
        if (value) {
          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              getBloc.getConfigureBloc(context);
            });
          });
        }
      });
    }
  }
}

class PasswordDialog {
  static void displayDialog(context) {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    var alertStyle = AlertStyle(
      //overlayColor: Colors.blue[400],
      animationType: AnimationType.fromTop,
      isCloseButton: false,
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
        style: alertStyle,
        title: "Change Safe Key",
        content: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Old Safe Key',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'New Safe Key',
                ),
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (oldPasswordController.text.trim().isEmpty) {
                OpenDialog.displayDialog("Error", context,
                    "Old safe key can't be empty", AlertType.error);
              } else if (newPasswordController.text.trim().isEmpty) {
                OpenDialog.displayDialog("Error", context,
                    "New safe key can't be empty", AlertType.error);
              } else {
                CheckAdminBloc checkBloc = CheckAdminBloc();
                ChangeSafeKeyBloc changeBloc = ChangeSafeKeyBloc();
                String oldPassword = oldPasswordController.text;
                String newPassword = newPasswordController.text;
                checkBloc.checkAdminBloc(context, oldPassword).then((value) {
                  if (value) {
                    changeBloc
                        .changeSafeKeyBloc(context, newPassword, oldPassword)
                        .then((value) {
                      if (value) {
                        OpenDialog.displayDialog(
                            "Success", context, "Success", AlertType.success);
                      } else {
                        OpenDialog.displayDialog(
                            "Error", context, "Failed", AlertType.error);
                      }
                    });
                  } else {
                    OpenDialog.displayDialog("Error", context,
                        "Old safe key is incorrect", AlertType.error);
                  }
                });
              }
            },
            child: Text(
              "Check",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
