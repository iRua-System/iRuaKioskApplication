import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/updateService.dart';
import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogCount.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UpdateServiceBloc {
  StreamController updateServiceStream = new StreamController();
  StreamController isCheckingStream = new StreamController();
  Stream get updateServicePrice => updateServiceStream.stream;
  Stream get isChecking => isCheckingStream.stream;
  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference storageReference;
  late UploadTask uploadTask;

  Future<bool> updateServiceBloc(Service service, MyFile img, context) async {
    isCheckingStream.sink.add("Checking");
    print("Bloc Check");
    var updateProvider = UpdateServiceProvider();
    if (img.file != null) {
      var filename =
          img.file!.path.substring(img.file!.path.lastIndexOf('/') + 1);
      storageReference =
          FirebaseStorage.instance.ref().child('Services/' + filename);
      uploadTask = storageReference.putFile(img.file!);
      await uploadTask.then((res) {
        res.ref.getDownloadURL().then((value) {
          service.photo = value;
        });
      });
    }
    var result =
        await updateProvider.updateServiceProvider(service).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    Navigator.of(context).pop();
    if (result) {
      CountDialog.displayDialog(
          "Success", context, "Update Succeeded", AlertType.success, 2);
      isCheckingStream.sink.add("Done");
      return true;
    } else {
      OpenDialog.displayDialog(
          "Error", context, "Update Unsucceeded", AlertType.error);
      print("alo");
      isCheckingStream.sink.add("Done");
      return false;
    }
  }

  void dispose() {
    isCheckingStream.close();
    updateServiceStream.close();
  }
}
