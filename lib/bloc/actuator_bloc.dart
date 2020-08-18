import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:thesis_demo/model/actuatorModel.dart';
import 'package:thesis_demo/model/roomModel.dart';
import 'package:thesis_demo/networking/apiHelper.dart';

part 'actuator_event.dart';

part 'actuator_state.dart';

class ActuatorBloc extends Bloc<ActuatorEvent, ActuatorState> {
  @override
  ActuatorState get initialState => ActuatorInitial();

  @override
  Stream<ActuatorState> mapEventToState(ActuatorEvent event) async* {
    if (event is GetActuators) {
      yield* _mapGetActuatorsToState(event);
    }
    if (event is UpdateActuator) {
      yield* _mapUpdateActuatorToState(event);
    }
    if (event is UpdateAutomationStatus) {
      yield* _mapUpdateAutomationStatusToState(event);
    }
    if (event is UpdateAllActuators) {
      yield* _mapUpdateAllActuatorsToState(event);
    }
  }

  Stream<ActuatorState> _mapGetActuatorsToState(GetActuators event) async* {
    try {
      yield ActuatorLoading();

      List<Actuator> _actuators = List<Actuator>();
      final response = await ApiHelper().getData();

      for (int i = 0; i < response["items"].length; i++) {
        _actuators.add(Actuator.fromJson(response["items"][i]));
      }

      Room _room = Room.fromJson(response);
      _room.actuators = _actuators;

      yield ActuatorLoaded(_room);
    } catch (_) {
      yield ActuatorError();
    }
  }

  Stream<ActuatorState> _mapUpdateActuatorToState(UpdateActuator event) async* {
    try {
      ApiHelper().postActuatorStatus(
          event.actuatorName, event.actuatorType, event.actuatorStatus);

      Room _room = (state as ActuatorLoaded).room;

      List<Actuator> _actuators = (state as ActuatorLoaded).room.actuators;

      for (int i = 0; i < _actuators.length; i++) {
        if (_actuators[i].name == event.actuatorName) {
          _actuators[i].status = event.actuatorStatus;
        }
      }

      _room.actuators = _actuators;

      yield ActuatorLoaded(_room);
    } catch (_) {
      yield ActuatorError();
    }
  }

  Stream<ActuatorState> _mapUpdateAutomationStatusToState(
      UpdateAutomationStatus event) async* {
    try {
      ApiHelper().postAutomationStatus(event.automationStatus);

      Room _room = (state as ActuatorLoaded).room;
      _room.automation = event.automationStatus;

      yield ActuatorLoaded(_room);
    } catch (_) {
      yield ActuatorError();
    }
  }

  Stream<ActuatorState> _mapUpdateAllActuatorsToState(
      UpdateAllActuators event) async* {
    try {
      Room _room = (state as ActuatorLoaded).room;

      for (int i = 0; i < _room.actuators.length; i++) {
        _room.actuators[i].status = event.status;
        ApiHelper().postActuatorStatus(
            _room.actuators[i].name, _room.actuators[i].type, event.status);
      }

      yield ActuatorLoaded(_room);
    } catch (_) {
      yield ActuatorError();
    }
  }
}
