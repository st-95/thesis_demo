class Actuator {
  String name;
  String type;
  num status;

  Actuator(this.name, this.type, this.status);

  Actuator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    status = json['status'];
  }
}