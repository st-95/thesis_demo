import 'package:flutter/material.dart';
import 'package:thesis_demo/bloc/actuator_bloc.dart';
import 'package:thesis_demo/layout/snackBarHelper.dart';
import 'package:thesis_demo/model/actuatorModel.dart';
import 'package:thesis_demo/ressources/colors.dart';

class GridItem extends StatefulWidget {
  final Actuator actuator;
  final ActuatorBloc actuatorBloc;

  GridItem(this.actuator, this.actuatorBloc);

  @override
  _GridItemState createState() => _GridItemState(actuator, actuatorBloc);
}

class _GridItemState extends State<GridItem> {
  final Actuator actuator;
  final ActuatorBloc actuatorBloc;
  static var status;

  _GridItemState(this.actuator, this.actuatorBloc);

  @override
  Widget build(BuildContext context) {
    status = actuator.status;
    var icon;

    if (actuator.type == "low voltage") {
      icon = Icon(Icons.lightbulb_outline, color: iconColor);
    } else {
      icon = Icon(Icons.cloud_queue, color: iconColor);
    }
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: gridBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: gridShadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[icon, _dotWidget(actuator.status)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(actuator.name),
              Switch(
                value: status == 1 ? true : false,
                activeColor: switchActiveColor,
                onChanged: (newValue) => {
                  if ((actuatorBloc.state as ActuatorLoaded).room.automation ==
                      "on")
                    {
                      status = !newValue,
                      Scaffold.of(context).showSnackBar(snackBarHelper)
                    }
                  else
                    {
                      status = newValue == true ? 1 : 0,
                      actuatorBloc.add(
                          UpdateActuator(actuator.name, actuator.type, status))
                    }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _dotWidget(int status) {
    Color color;
    // actuator is active
    if (status == 1) {
      color = dotActiveColor;
    }
    // actuator is not active
    else {
      color = dotNotActiveColor;
    }

    return ClipOval(
      child: Material(
          color: color,
          child: SizedBox(
            height: 12,
            width: 12,
          )),
    );
  }
}
