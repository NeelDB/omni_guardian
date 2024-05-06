import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:omni_guardian/storage/storage.dart';

import 'alert.dart';

class Photo {

  static const String _photosDir = "lib/data/photos";
  static const String _jpeg = "jpeg";

  static Future<void> savePhoto(String alertJson) async {
    await deletePhotoStorage();

    Alert alert = jsonDecode(alertJson);
    File imageFile = File("$_photosDir/${alert.timestamp}.$_jpeg");
    Uint8List photoBytes = base64.decode(alert.imageBytes);

    await imageFile.writeAsBytes(photoBytes);
    Storage.updateAlertStorage(alertJson);
  }


  static Future<void> savePhotos(String listAlertJson) async {
    await deletePhotoStorage();

    List<Alert> alerts = jsonDecode(listAlertJson);
    for(Alert alert in alerts) {
      File imageFile = File("$_photosDir/${alert.timestamp}");
      Uint8List photoBytes = base64.decode(alert.imageBytes);
      await imageFile.writeAsBytes(photoBytes);
    }

    Storage.updateAlertStorage(jsonEncode(alerts.last.toJson()));
  }


  static Future<void> deletePhotoStorage() async {
    Directory directory = Directory(_photosDir);
    List<FileSystemEntity> files = directory.listSync();

    for (FileSystemEntity file in files) {
      await file.delete();
    }
  }

}