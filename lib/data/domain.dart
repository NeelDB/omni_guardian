import 'package:omni_guardian/data/User.dart';
import 'package:omni_guardian/data/Camera.dart';
import 'package:omni_guardian/data/alert.dart';

class Domain {
  String domain;
  List<Camera> cameras;
  List<User> users;
  List<Alert> alerts;
  String address;
  String guestCode;
  String alarmCode;
  String authorizationToken;

  Domain(
      this.domain,
      this.cameras,
      this.users,
      this.alerts,
      this.address,
      this.guestCode,
      this.alarmCode,
      this.authorizationToken
      );


  Map<String, dynamic> toJson() {
    return {
      'domain' : domain,
      'cameras' : cameras,
      'users' : users,
      'alerts' : alerts,
      'address' : address,
      'guestCode' : guestCode,
      'alarmCode' : alarmCode,
      'authorizationToken' : authorizationToken
    };
  }
}