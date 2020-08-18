import 'package:thesis_demo/model/actuatorModel.dart';

class Room {
  String automation;
  String advice;
  List<Actuator> actuators;

  Room(this.automation, this.advice, this.actuators);

  Room.fromJson(Map<String, dynamic> json) {
    automation = json['automation'];
    advice = json['advice'];
  }
}