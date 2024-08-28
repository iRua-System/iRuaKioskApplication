import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/createService.dart';

import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/service.dart';

import 'package:kiosk/models/vehicleType.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogCount.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CreateServiceBloc {
  StreamController createServiceStream = new StreamController();
  StreamController isCheckingStream = new StreamController();
  Stream get createService => createServiceStream.stream;
  Stream get isChecking => isCheckingStream.stream;
  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference storageReference;
  late UploadTask uploadTask;

  Future<bool> createServiceBloc(
      context, Service service, List<VehicleType> prices, MyFile img) async {
    isCheckingStream.sink.add("Checking");
    print("Bloc Check");
    var createService = CreateServiceProvider();

    var filename = img.file?.path.substring(img.file!.path.lastIndexOf('/') + 1);
    storageReference =
        FirebaseStorage.instance.ref().child('Services/' + filename!);
    uploadTask = storageReference.putFile(img.file!);
    await uploadTask.then((res){
      res.ref.getDownloadURL().then((value) {
      service.photo = value;});
    });
    
    var result =
        await createService.createServiceMember(service, prices).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    Navigator.of(context).pop();
    if (result) {
      CountDialog.displayDialog(
          "Success", context, "Tạo dịch vụ thành công", AlertType.success,2);
      isCheckingStream.sink.add("Done");
      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Tạo dịch vụ không thành công", AlertType.error);
      print("alo");
      isCheckingStream.sink.add("Done");
      return false;
    }
  }

  void dispose() {
    isCheckingStream.close();
    createServiceStream.close();
  }
}
