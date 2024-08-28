import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/getAllFeedback_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/feedback_column.dart';

class FeedbackManage extends StatefulWidget {
  @override
  _FeedbackManageState createState() => _FeedbackManageState();
}

class _FeedbackManageState extends State<FeedbackManage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  GetAllFeedbackBloc getBloc = GetAllFeedbackBloc();
  List<String> listStart = [
    "All",
    "1. Not satisfied",
    "2. Not good",
    "3. Acceptable",
    "4. Happy",
    "5. Fabulous"
  ];
  String selectedStart = '';
  @override
  void initState() {
    getBloc.getAllFeedbackBloc(context);
    selectedStart = listStart[0];
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController searchController = TextEditingController();

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
                                'Customers\' feedbacks',
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<String>(
                                  // iconDisabledColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  underline: SizedBox(),
                                  value: selectedStart,
                                  items: listStart.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Row(children: <Widget>[
                                        Text(
                                          e.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        )
                                      ]),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedStart = newValue!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Container(
                              width: width / 6,
                              child: Text(
                                'Employee name: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                height: 60,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  onChanged: (value) {
                                    getBloc.searchByName(value);
                                  },
                                  style: TextStyle(fontSize: 25),
                                  //textAlign: TextAlign.right,
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    //suffix: Icon(Icons.phone,color: Colors.black,),
                                    //labelText: 'Số điện thoại',
                                    // labelStyle: TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff20b9f5), width: 2.0),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          // width: width * 0.7,
                          height: height * 0.5 - 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff1fa2ff).withOpacity(0.6),
                            // boxShadow: [
                            //   BoxShadow(
                            //     offset: Offset(0, 4),
                            //     blurRadius: 10,
                            //   )
                            // ],
                          ),
                          child: Column(children: [
                            // Container(
                            //   width: width * 0.7,
                            //   height: 60,
                            //   child: ServiceManageHeaderColumn(
                            //     photo: "Hình ảnh",
                            //     title: "Tên dịch vụ",
                            //     price: "Giá tiền VND",
                            //     width: width,
                            //   ),
                            // ),
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
                                      stream: getBloc.getFeedback,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != "Aloha") {
                                          var data = snapshot.data
                                              as List<Transaction>;
                                          List<Transaction> feedbacks = [];
                                          if (selectedStart == "All") {
                                            feedbacks = data;
                                          } else if (selectedStart ==
                                              "1. Not satisfied") {
                                            for (var feedback in data) {
                                              if (feedback
                                                      .feedback!.starPoint ==
                                                  "1") {
                                                feedbacks.add(feedback);
                                              }
                                            }
                                          } else if (selectedStart ==
                                              "2. Not good") {
                                            for (var feedback in data) {
                                              if (feedback
                                                      .feedback!.starPoint ==
                                                  "2") {
                                                feedbacks.add(feedback);
                                              }
                                            }
                                          } else if (selectedStart ==
                                              "3. Acceptable") {
                                            for (var feedback in data) {
                                              if (feedback
                                                      .feedback!.starPoint ==
                                                  "3") {
                                                feedbacks.add(feedback);
                                              }
                                            }
                                          } else if (selectedStart ==
                                              "4. Happy") {
                                            for (var feedback in data) {
                                              if (feedback
                                                      .feedback!.starPoint ==
                                                  "4") {
                                                feedbacks.add(feedback);
                                              }
                                            }
                                          } else if (selectedStart ==
                                              "5. Fabulous") {
                                            for (var feedback in data) {
                                              if (feedback
                                                      .feedback!.starPoint ==
                                                  "5") {
                                                feedbacks.add(feedback);
                                              }
                                            }
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              for (var data in feedbacks)
                                                FeedbackColumn(
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
                                                'Currently, the store has not received any feedback.',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            ),
                                          );
                                        } else {
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
}

class ServiceManageHeaderColumn extends StatelessWidget {
  final String title;
  final String price;
  final double width;
  final String photo;
  ServiceManageHeaderColumn(
      {required this.price,
      required this.title,
      required this.width,
      required this.photo});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.15,
                child: Text(
                  photo,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              //SizedBox(width:30),
              Container(
                width: width * 0.25,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Spacer(),
              Container(
                width: 160,
                //color: Colors.white,
                child: Text(
                  price,
                  //textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
