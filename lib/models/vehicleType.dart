import 'package:flutter/material.dart';

class VehicleType{
  String? id;
  String? name;
  bool? check ;
  List<String>? brand;
  TextEditingController? controller;
  String? price;
  String? time;
  TextEditingController? timeController;
  VehicleType({this.name,this.id,this.brand,this.check, controller, this.price, this.timeController, this.time});

  Map<String, dynamic> toJson() {
    return {
      "vehicleTypeId": this.id,
      "price" : this.price,
      'estimatedTime' : this.time 
    };
  }

}