class User {
  String firstname;
  String lastname;
  String email;
  String ip;
  String domain;
  String guestCode;
  String alarmCode;
  bool isAdmin;
  String authorizationToken;
  String password;

  User(
      this.firstname,
      this.lastname,
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
      'firstname' : firstname,
      'lastname' : lastname,
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