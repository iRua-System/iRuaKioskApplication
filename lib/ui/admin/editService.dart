import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk/bloc/createService_bloc.dart';
import 'package:kiosk/bloc/getVehicleTypeChip_bloc.dart';
import 'package:kiosk/bloc/updateService_bloc.dart';

import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/servicePrice.dart';
import 'package:kiosk/models/vehicleType.dart';
import 'package:kiosk/ui/widgets/backButton.dart';

class EditService extends StatefulWidget {
  final Service service;

  const EditService({Key? key, required this.service}) : super(key: key);
  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetServicesOfVehicleTypeChipBloc getBloc = GetServicesOfVehicleTypeChipBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  UpdateServiceBloc updateBloc = UpdateServiceBloc();
  @override
  void initState() {
    getBloc.getVehicleTypeChipBloc(context);
    nameController..text = widget.service.name!;
    desController..text = widget.service.description!;
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  bool editPrice = false;
  final _formKey = GlobalKey<FormState>();

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
                            ? NetworkImage(widget.service.photo!)
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
                    if (!editPrice) {
                      TextEditingController controller =
                          TextEditingController();
                      TextEditingController timeController =
                          TextEditingController();
                      data.controller = controller;
                      data.timeController = timeController;
                      for (var vehicleType in widget.service.prices) {
                        if (vehicleType.name == data.name) {
                          data.check = true;
                          data.controller!
                            ..text = vehicleType.price.split(".")[0];
                          data.timeController!
                            ..text = vehicleType.estimatedTime!;
                        }
                      }
                      controller.addListener(() {
                        setState(() {
                          editPrice = true;
                        });
                      });
                    } else {}

                    // for (var vehicleType in widget.service.prices) {
                    //   if (!editPrice) {
                    //     if (vehicleType.name == data.name) {
                    //       data.check = true;
                    //       data.controller
                    //         ..text = vehicleType.price.split(".")[0];
                    //     }
                    //   }
                    // }
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
                                      left: 50.0, top: 50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        width: width / 4,
                                        child: Text(
                                          'Update service',
                                          style: TextStyle(
                                              color: Color(0xff1fa2ff),
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          width: width / 3,
                                          child: Text(
                                            'Service name',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 70,
                                          width: width * 0.4,
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 20),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Name can't be empty";
                                              }
                                              if (value.length < 5) {
                                                print(value.length);
                                                return "Name can't be less than 5 characters";
                                              }
                                              return null;
                                            },
                                            //initialValue: widget.service.name,
                                            //textAlign: TextAlign.right,
                                            controller: nameController..text,
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
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          width: width / 3,
                                          child: Text(
                                            'Description',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 110,
                                        width: width * 0.4,
                                        child: TextFormField(
                                          style: TextStyle(fontSize: 20),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Description can't be empty";
                                            }
                                            if (value.length < 10) {
                                              return "Description can't be less than 10 characters";
                                            }
                                            return null;
                                          },
                                          maxLines: 2,
                                          //initialValue: widget.service.description,
                                          //textAlign: TextAlign.right,
                                          controller: desController..text,
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
                                      SizedBox(height: 10),
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
                                      SizedBox(height: 10),
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
                                                  'UPDATE',
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

  edit() {
    setState(() {
      editPrice = true;
    });
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
                              return "Giá cho loại xe không được trống";
                            }
                            if (num.tryParse(value)! < 10) {
                              return "Giá tối thiểu cho 1 dịch vụ là trên 10.000 VNĐ";
                            }
                          }
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
                    Text(
                      ' 000 VNĐ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
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
                              return "Thời gian thực hiện không được trống";
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
                      ' phút',
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
              editPrice = true;
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

  void onSignInClicked(BuildContext context, List<VehicleType> vehicleList) {
    FocusScope.of(context).unfocus();
    if (this._formKey.currentState!.validate()) {
      this.showDialogConfirmActive();
      String name = nameController.text;
      String des = desController.text;
      List<ServicePrice> prices = [];
      // for (var data in widget.service.prices) {
      //   for (var vehicleType in vehicleList) {
      //     if (vehicleType.check == true && vehicleType.name == data.name) {
      //       data.price = vehicleType.controller.text;
      //       data.serviceVehicleId = vehicleType.id;
      //       data.isActive = true;
      //       prices.add(data);
      //     }else if(vehicleType.check == false && vehicleType.name == data.name){
      //       data.price = vehicleType.controller.text;
      //       data.serviceVehicleId = vehicleType.id;
      //       data.isActive = false;
      //       prices.add(data);
      //     }
      //   }
      // }
      for (var data in vehicleList) {
        if (data.check!) {
          var price = data.controller!.text;
          var time = data.timeController!.text;
          var serviceVehicleId = data.id;

          ServicePrice temp = ServicePrice(
              price: price,
              estimatedTime: time,
              serviceVehicleId: serviceVehicleId!,
              isActive: true,
              name: '');
          prices.add(temp);
        } else {
          var price = data.controller!.text;
          var time = data.timeController!.text;
          var serviceVehicleId = data.id;

          ServicePrice temp = ServicePrice(
              price: price,
              estimatedTime: time,
              serviceVehicleId: serviceVehicleId!,
              isActive: false,
              name: '');
          prices.add(temp);
        }
      }
      widget.service.prices = prices;
      widget.service.name = name;
      widget.service.description = des;

      updateBloc.updateServiceBloc(widget.service, img, context);
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
