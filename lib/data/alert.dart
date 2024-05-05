import 'dart:typed_data';

class Alert {
  String timestamp;
  Uint8List imageBytes;
  bool isFalseAlarm;
  String domain;
  String camera;

  Alert(
      this.timestamp,
      this.imageBytes,
      this.isFalseAlarm,
      this.domain,
      this.camera
      );


  Map<String, dynamic> toJson() {
    return {
      'timestamp' : timestamp,
      'imageBytes' : imageBytes,
      'isFalseAlarm' : isFalseAlarm,
      'domain' : domain,
      'camera' : camera
    };
  }
}