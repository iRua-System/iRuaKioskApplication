




import 'package:kiosk/models/employee.dart';
import 'package:kiosk/models/feedback.dart';
import 'package:kiosk/models/service.dart';

import 'customer.dart';

class Transaction {
  String? id;
  String? bookingDate;
  String? status;
  String? price;
  List<Service>? services;
  String? vehiclePlate;
  String? vehicleName;
  String? vehicleId;
  Customer? cust;
  Employee? emp;
  String? vehicleBrand;
  Feedback? feedback;
  String? finishedDate;
  String? payment;
  Transaction(
      {this.id,
      this.vehicleId,
      this.bookingDate,
      this.status,
      this.price,
      this.services,
      this.cust,
      this.vehicleName,
      this.vehiclePlate,this.emp,this.vehicleBrand, this.feedback,this.finishedDate,this.payment});
}
