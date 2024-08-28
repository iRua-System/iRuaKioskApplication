class ServicePrice{
  String serviceVehicleId;
  String name;
  String price;
  bool? isActive;
  String? estimatedTime;
  ServicePrice({required this.price,required this.name,required this.serviceVehicleId,this.isActive, this.estimatedTime});

  Map<String, dynamic> toJson() {
    return {
      "vehicleTypeId": this.serviceVehicleId,
      "price" : this.price,
      "isActive" : this.isActive,
      "estimatedTime" : this.estimatedTime
    };
  }
}