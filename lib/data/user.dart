class User {
  String firstName;
  String lastName;
  String email;
  String ip;
  String domain;
  String guestCode;
  String alarmCode;
  bool isAdmin;
  String authorizationToken;
  String password;

  User(
      this.firstName,
      this.lastName,
      this.email,
      this.ip,
      this.domain,
      this.guestCode,
      this.alarmCode,
      this.isAdmin,
      this.authorizationToken,
      this.password
      );


  Map<String, dynamic> toJson() {
    return {
      'firstName' : firstName,
      'lastName' : lastName,
      'email' : email,
      'ip' : ip,
      'domain' : domain,
      'guestCode' : guestCode,
      'alarmCode' : alarmCode,
      'isAdmin' : isAdmin,
      'authorizationToken' : authorizationToken,
      'password' : password
    };
  }
}