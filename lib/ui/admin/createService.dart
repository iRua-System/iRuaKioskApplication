import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk/bloc/createService_bloc.dart';
import 'package:kiosk/bloc/getVehicleTypeChip_bloc.dart';

import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/vehicleType.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreateService extends StatefulWidget {
  @override
  _CreateService createState() => _CreateService();
}

class _CreateService extends State<CreateService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetServicesOfVehicleTypeChipBloc getBloc = GetServicesOfVehicleTypeChipBloc();
  @override
  void initState() {
    getBloc.getVehicleTypeChipBloc(context);
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  CreateServiceBloc bloc = CreateServiceBloc();
  MyFile img = MyFile();
  List<VehicleType> temp = [];
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
              left: width / 12,
              top: height / 5,
              child: Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: img.file == null
                            ? AssetImage("assets/icons/camera.png")
                                as ImageProvider
                            : FileImage(img.file!) as ImageProvider)),
              ),
            ),
            Positioned(
              left: width / 8,
              top: height / 2.5,
              child: GestureDetector(
                onTap: () {
                  ImagePicker picker = ImagePicker();
                  picker.pickImage(source: ImageSource.gallery).then((value) {
                    if (value != null) {
                      setState(() {
                        img.file = value as File?;
                        img.url = value.path;
                      });
                    }
                  });
                },
                child: Container(
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text("Select",
                        style: TextStyle(
                            color: Color(0xff1fa2ff),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 30,
              top: 50,
              child: MyBackButton(color: Colors.white),
            ),
            StreamBuilder(
              stream: getBloc.vehicleType,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  temp = snapshot.data as List<VehicleType>;
                  for (var data in temp) {
                    if (data.check == null || data.check == false) {
                      TextEditingController controller =
                          TextEditingController();
                      data.controller = controller;
                      data.timeController = controller;
                    }
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        width: width * 0.6,
                        decoration: BoxDecoration(color: Colors.white),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, top: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width / 3,
                                        child: Text(
                                          'Create new service',
                                          style: TextStyle(
                                              color: Color(0xff1fa2ff),
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 10,
                                              child: Text(
                                                'Name',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 10,
                                              child: Text(
                                                '(*)',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          height: 70,
                                          width: width * 0.4,
                                          child: TextFormField(
                                            maxLength: 20,
                                            style: TextStyle(fontSize: 20),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Name can't be empty";
                                              }
                                              if (value.length > 5) {
                                                return "Name can't be less than 5 characters";
                                              }
                                              return null;
                                            },
                                            //textAlign: TextAlign.right,
                                            controller: nameController..text,
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
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 19,
                                              child: Text(
                                                'Description',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              width: width / 10,
                                              child: Text(
                                                '(*)',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 110,
                                        width: width * 0.4,
                                        child: TextFormField(
                                          maxLength: 100,
                                          style: TextStyle(fontSize: 20),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Description can't be empty";
                                            }
                                            if (value.length > 10) {
                                              return "Description can't be less than 10 characters";
                                            }
                                            return null;
                                          },
                                          maxLines: 2,
                                          //textAlign: TextAlign.right,
                                          controller: desController..text,
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          width: width / 3,
                                          child: Text(
                                            'Service fees corresponding to the vehicle type: ',
                                            style: TextStyle(
                                                color: Color(0xff1fa2ff),
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          for (var data in temp) chip(data),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          for (var data in temp)
                                            serviceVehiclePrice(
                                                width,
                                                data.name,
                                                data.controller!,
                                                data.check,
                                                "Time",
                                                data.timeController),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        height: 100,
                                        width: width * 0.5,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                width: 1,
                                                color: Colors.grey[400]!),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              onSignInClicked(context, temp);
                                            },
                                            child: Container(
                                              height: 60,
                                              child: Container(
                                                width: width / 5,
                                                child: Text(
                                                  'CREATE SERVICE',
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  serviceVehiclePrice(double width, vehicleType,
      TextEditingController controller, check, time, timeController) {
    if (check) {
      return Container(
        width: width * 0.4,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: width * 0.2,
                    child: Text(
                      vehicleType,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: width * 0.1,
                      child: TextFormField(
                        validator: (value) {
                          if (check) {
                            if (value!.isEmpty) {
                              return "Price for the vehicle type must not be empty.";
                            }
                            if (int.tryParse(value)! < 10) {
                              return "Price for the vehicle type must not be less than \$10";
                            }
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 20),
                        //textAlign: TextAlign.right,
                        controller: controller,
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
                    // Text(
                    //   ' 000 VNĐ',
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 20,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: width * 0.2,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: width * 0.1,
                      child: TextFormField(
                        validator: (value) {
                          if (check) {
                            if (value!.isEmpty) {
                              return "Execution time must not be empty.";
                            }
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 20),
                        //textAlign: TextAlign.right,
                        controller: timeController,
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
                    Text(
                      ' minutes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget chip(data) {
    return Row(
      children: [
        FilterChip(
          showCheckmark: false,
          avatar: data.check
              ? Icon(Icons.check, color: Colors.blue)
              : Icon(Icons.add, color: Colors.grey),
          label: Text(data.name,
              style: TextStyle(
                  fontSize: 25, color: data.check ? Colors.blue : Colors.grey)),
          labelStyle: TextStyle(color: data.check ? Colors.blue : Colors.white),
          selected: data.check,
          selectedColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: data.check ? Colors.blue : Colors.grey,
            ),
          ),
          onSelected: (value) {
            setState(() {
              data.check = value;
            });
          },
          // selectedColor:
          //     Theme.of(context).accentColor,
          checkmarkColor: Colors.black,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  void onSignInClicked(BuildContext context, List<VehicleType> listVehicle) {
    FocusScope.of(context).unfocus();
    if (this._formKey.currentState!.validate()) {
      if (img.file != null) {
        List<VehicleType> prices = [];
        var name = nameController.text;
        for (var data in listVehicle) {
          if (data.check!) {
            if (data.controller!.text.trim() != "" &&
                data.timeController!.text.trim() != "") {
              VehicleType type = VehicleType(
                  id: data.id,
                  price: data.controller!.text,
                  time: data.timeController!.text);
              prices.add(type);
            } else {
              OpenDialog.displayDialog(
                  "Error",
                  context,
                  "Please enter the prices for the selected services!!!",
                  AlertType.error);
            }
          }
        }
        if (prices.length > 0) {
          this.showDialogConfirmActive();
          Service service = Service(
              name: name,
              file: img,
              description: desController.text,
              vehicleName: '',
              prices: []);
          bloc.createServiceBloc(context, service, prices, img);
        }
      } else {
        OpenDialog.displayDialog("Error", context,
            "Please select the picture for the service!!!", AlertType.error);
      }
    }
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
