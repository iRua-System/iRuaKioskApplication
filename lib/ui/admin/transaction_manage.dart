import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/getAllEmployees_bloc.dart';
import 'package:kiosk/bloc/getAllTransactions_bloc.dart';
import 'package:kiosk/bloc/getStoreConfigure_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/historytransaction_column.dart';

class TransactionManage extends StatefulWidget {
  @override
  _TransactionManageState createState() => _TransactionManageState();
}

class _TransactionManageState extends State<TransactionManage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  GetAllTransactionBloc getBloc = GetAllTransactionBloc();
  GetConfigureBloc systemBloc = GetConfigureBloc();
  GetAllEmployeeBloc empBloc = GetAllEmployeeBloc();
  List<String> listEmp = [];
  String selectedEmp = '';
  String startDate = '', endDate = '';
  @override
  void initState() {
    listEmp.add("All");
    empBloc.getAllEmployeeBloc(context).then((value) {
      if (value != null) {
        for (var data in value) {
          String name = data.fullname;
          setState(() {
            listEmp.add(name);
          });
        }
      }
    });
    systemBloc.getSystemBloc(context, false).then((value) {
      if (value != null) {
        setState(() {
          startDate = value.toString();
          print(value);
          endDate = value.toString();
          var temp = startDate.split(" ")[0];
          var day = temp.split("/")[1];
          var month = temp.split("/")[0];
          var year = temp.split("/")[2];
          startController..text = day + "/" + month + "/" + year;
          endController..text = day + "/" + month + "/" + year;
          getBloc.getAllTransactionBloc(
              context, startController.text, endController.text);
        });
      }
    });

    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

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
        child: Stack(children: [
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
              SingleChildScrollView(
                child: Container(
                  width: width * 0.87,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: width / 3,
                              child: Text(
                                'Transaction history',
                                style: TextStyle(
                                    color: Color(0xff1fa2ff),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text('Filter : ',
                                style: TextStyle(
                                    color: Color(0xff1fa2ff),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            buildFilter(),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Container(
                              width: width / 10,
                              child: Text(
                                'From',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                startDatePicker(
                                    context, startController, startDate);
                              },
                              child: Container(
                                height: 60,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  enabled: false,
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.right,
                                  controller: startController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff20b9f5), width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: width / 9,
                              child: Text(
                                'To',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                startDatePicker(
                                    context, endController, endDate);
                              },
                              child: Container(
                                height: 60,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  enabled: false,
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.right,
                                  controller: endController,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff20b9f5), width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                getBloc.getAllTransactionBloc(context,
                                    startController.text, endController.text);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  height: 50,
                                  width: width * 0.1,
                                  child: Text(
                                    'Find',
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: height * 0.5 - 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff1fa2ff).withOpacity(0.6),
                          ),
                          child: Column(children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  // height: height * 0.55,
                                  width: width * 0.78,
                                  decoration: BoxDecoration(
                                      //color: Color(0xff1fa2ff).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: StreamBuilder(
                                      stream: getBloc.getTransaction,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != "Aloha" &&
                                            snapshot.data != "Checking") {
                                          List<Transaction> temp = [];
                                          temp = snapshot.data
                                              as List<Transaction>;
                                          List<Transaction> transaction = [];
                                          if (selectedEmp == "All") {
                                            transaction = temp;
                                          } else {
                                            transaction = temp
                                                .where((element) => element
                                                    .emp!.fullname
                                                    .contains(selectedEmp))
                                                .toList();
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              for (var data in transaction)
                                                HistoryTransactionColumn(
                                                  transaction: data,
                                                ),
                                              SizedBox(height: 30),
                                            ],
                                          );
                                        } else if (snapshot.data == "Aloha") {
                                          return Container(
                                            height: height * 0.5,
                                            child: Center(
                                              child: Text(
                                                'There is no transaction',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.data ==
                                            "Checking") {
                                          return Container(
                                            height: height * 0.5,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 7,
                                                backgroundColor:
                                                    AppColor.PRIMARY_TEXT_WHITE,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                                'There is no transaction during this time frame'),
                                          );
                                        }
                                      }),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 50,
            top: -50,
            child: Container(
              height: height / 5,
              width: width / 5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/icon.png"))),
            ),
          ),
        ]),
      ),
    );
  }

  startDatePicker(context, controller, date) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              //
              onDateTimeChanged: (picked) {
                if (picked != null && picked.toString() != startDate)
                  setState(() {
                    date = picked.toString();
                    // var temp = DateFormat("dd-MM-yyyy").parse(startDate);
                    var year = date.split("-")[0];
                    var month = date.split("-")[1];
                    var day = date.split("-")[2].split(" ")[0];
                    controller.text = day + "/" + month + "/" + year;
                  });
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2020,
              maximumYear: 2025,
            ),
          );
        });
  }

  Container buildFilter() {
    if (listEmp.length > 0) {
      if (selectedEmp == "") {
        selectedEmp = listEmp[0];
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<String>(
            // iconDisabledColor: Colors.white,
            dropdownColor: Colors.white,
            underline: SizedBox(),
            value: selectedEmp,
            items: listEmp.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Row(children: <Widget>[
                  Text(
                    e.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
                ]),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedEmp = newValue!;
              });
            }),
      );
    } else {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)));
    }
  }
}
