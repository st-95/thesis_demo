part of 'actuator_bloc.dart';

@immutable
abstract class ActuatorState {}

class ActuatorInitial extends ActuatorState {}

class ActuatorLoading extends ActuatorState {}

class ActuatorError extends ActuatorState {}

class ActuatorLoaded extends ActuatorState {
  final Room room;
  ActuatorLoaded(this.room);
}
