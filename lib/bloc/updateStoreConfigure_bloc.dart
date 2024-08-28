import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kiosk/dataprovider/updateStoreConfigure.dart';
import 'package:kiosk/models/myfile.dart';
import 'package:kiosk/models/store.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UpdateStoreConfigureBloc {
  StreamController updateStoreConfigStream = new StreamController();
  StreamController isCheckingStream = new StreamController();
  Stream get updateStoreConfig => updateStoreConfigStream.stream;
  Stream get isChecking => isCheckingStream.stream;
  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference storageReference;
  late UploadTask uploadTask;

  Future<bool> updateStoreConfigureBloc(
      context, Store store, bool newImage, MyFile img) async {
    isCheckingStream.sink.add("Checking");
    print("Bloc Check");
    var storeProvider = UpdateStoreProvider();
    if (newImage) {
      var filename =
          img.file!.path.substring(img.file!.path.lastIndexOf('/') + 1);
      storageReference =
          FirebaseStorage.instance.ref().child('UserImage/' + filename);
      uploadTask = storageReference.putFile(img.file!);
      await uploadTask.then((res) {
        res.ref.getDownloadURL().then((value) {
          store.ownerImage = value;
        });
      });
    }

    var result =
        await storeProvider.updateStoreProvider(store).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result) {
      OpenDialog.displayDialog(
          "Success", context, "Update Succeeded", AlertType.success);
      isCheckingStream.sink.add("Done");
      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Update Unsucceeded", AlertType.error);
      print("alo");
      isCheckingStream.sink.add("Done");
      return false;
    }
  }

  void dispose() {
    isCheckingStream.close();
    updateStoreConfigStream.close();
  }
}
