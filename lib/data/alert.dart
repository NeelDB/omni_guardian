import 'dart:typed_data';

class Alert {
  String timestamp;
  Uint8List imageBytes;
  bool isFalseAlarm;
  String domain;

  Alert(
      this.timestamp,
      this.imageBytes,
      this.isFalseAlarm,
      this.domain
      );


  Map<String, dynamic> toJson() {
    return {
      'timestamp' : timestamp,
      'imageBytes' : imageBytes,
      'isFalseAlarm' : isFalseAlarm,
      'domain' : domain
    };
  }
}