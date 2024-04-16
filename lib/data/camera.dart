class Camera {
  String id;
  bool isOn;
  String domain;

  Camera(
      this.id,
      this.isOn,
      this.domain
      );


  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'isOn' : isOn,
      'domain' : domain
    };
  }
}