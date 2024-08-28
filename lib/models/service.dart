import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/servicePrice.dart';

class Service{
  String? id;
  String? name;
  String? description;
  String? price;
  String? serviceVehicleId; 
  String vehicleName;
  String? vehicleId;
  bool? check;
  String? photo;
  MyFile? file;
  bool? isNew;
  List<ServicePrice> prices;
    Service({this.id,this.name,this.description,this.price,this.serviceVehicleId, required this.vehicleName,this.vehicleId,this.check,this.photo,required this.prices, this.file,this.isNew});

  

}