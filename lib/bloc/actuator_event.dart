part of 'actuator_bloc.dart';

@immutable
abstract class ActuatorEvent {}

class GetActuators extends ActuatorEvent {
  GetActuators();
}

class UpdateActuator extends ActuatorEvent {
  final actuatorName;
  final actuatorType;
  final actuatorStatus;

  UpdateActuator(this.actuatorName, this.actuatorType, this.actuatorStatus);
}

class UpdateAutomationStatus extends ActuatorEvent {
  final automationStatus;

  UpdateAutomationStatus(this.automationStatus);
}

class UpdateAllActuators extends ActuatorEvent {
  final status;

  UpdateAllActuators(this.status);
}
