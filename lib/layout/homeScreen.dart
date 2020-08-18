import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thesis_demo/bloc/actuator_bloc.dart';
import 'package:thesis_demo/layout/snackBarHelper.dart';
import 'package:thesis_demo/model/roomModel.dart';
import 'package:thesis_demo/layout/gridItemHelper.dart';
import 'package:thesis_demo/model/actuatorModel.dart';
import 'package:thesis_demo/ressources/colors.dart';
import 'package:thesis_demo/ressources/strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final actuatorBloc = ActuatorBloc();
  var statusAutomation;

  @override
  void initState() {
    actuatorBloc.add(GetActuators());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocBuilder<ActuatorBloc, ActuatorState>(
        bloc: actuatorBloc,
        builder: (context, state) {
          if (state is ActuatorLoaded) {
            statusAutomation = state.room.automation;
            return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _buildScreen(state.room));
          }
          if (state is ActuatorLoading) {
            return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child:_loadingWidget());
          }
          return _loadingWidget();
        },
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(progressIndicatorValueColor),
          backgroundColor: progressIndicatorBackgroundColor,
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Text(loadData),
        )
      ],
    ));
  }

  Widget _buildScreen(Room room) {
    return LiquidPullToRefresh(
        onRefresh: () async {
          actuatorBloc.add(GetActuators());
        },
        color: actuatorsContainerShadowColor,
        backgroundColor: dotActiveColor,
        showChildOpacityTransition: false,
        springAnimationDurationInMilliseconds: 800,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 64),
                      child: SvgPicture.asset(
                        'assets/clean-air.svg',
                        width: 100,
                        height: 100,
                      )),
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(left: 64, right: 64),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: adviceBoxBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: actuatorsContainerShadowColor,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(advice),
                              Text(
                                room.advice,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: room.advice == "Lüften!"
                                        ? adviceColorRed
                                        : adviceColorGreen),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(automaticVentilation),
                              Switch(
                                  value:
                                      statusAutomation == "on" ? true : false,
                                  activeColor: switchActiveColor,
                                  onChanged: (newValue) => {
                                        statusAutomation =
                                            newValue == true ? "on" : "off",
                                        actuatorBloc.add(UpdateAutomationStatus(
                                            statusAutomation))
                                      })
                            ],
                          ),
                        ],
                      )),
                  _buildActuators(room.actuators, room.automation)
                ],
              ),
            )));
  }

  Widget _buildActuators(List<Actuator> actuators, String automationStatus) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: actuatorsContainerBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: actuatorsContainerShadowColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _buildGridItems(actuators),
            Container(
                margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Builder(
                      builder: (context) => RaisedButton(
                        child: Text(actuatorsOff),
                        color: actuatorButtonBackgroundColorLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: actuatorButtonBorderColor)),
                        onPressed: () => {
                          if (automationStatus == "on")
                            {Scaffold.of(context).showSnackBar(snackBarHelper)}
                          else {
                            actuatorBloc.add(UpdateAllActuators(0))
                          }
                        },
                      ),
                    ),
                    Builder(
                      builder: (context) => RaisedButton(
                          child: Text(actuatorsOn),
                          color: actuatorButtonBackgroundColorDark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  BorderSide(color: actuatorButtonBorderColor)),
                          onPressed: () => {
                                if (automationStatus == "on")
                                  {
                                    Scaffold.of(context)
                                        .showSnackBar(snackBarHelper)
                                  }
                                else {
                                  actuatorBloc.add(UpdateAllActuators(1))
                                }
                              }),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildGridItems(List<Actuator> actuators) {
    var gridList = new List<Widget>();

    for (int i = 0; i < actuators.length; i++) {
      gridList.add(GridItem(actuators[i], actuatorBloc));
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.4,
        children: gridList,
      ),
    );
  }
}
