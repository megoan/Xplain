import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/views/gamecreator/nextStep.dart';

import '../../myColors.dart';

class XplainScreen extends StatelessWidget {
  final String explainName;
  XplainScreen(this.explainName);

  Widget loadingName() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "X",
          style: TextStyle(color: Colors.yellow, fontSize: 230, fontFamily: 'Hobo'),
        ),
        Center(
          child: FlareActor("assets/bounce.flr", alignment: Alignment.center, fit: BoxFit.contain, animation: "Untitled"),
        ),
      ],
    );
  }

  Widget showName() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "X",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.yellow.withOpacity(0.2), fontSize: 230, fontFamily: 'Hobo'),
          ),
          Container(
            width: 350,
            height: 350,
            child: FlareActor("assets/firework_pink.flr",
                alignment: Alignment.center,
                //fit: BoxFit.contain,
                animation: "explode"),
          ),
          Text(
            explainName + "!!!",
            style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Hobo'),
          ),
        ],
      ),
    );
  }

  Widget getresultWrapper(String explainName, GameProvider gameProvider) {
    if (gameProvider.creatorLoggedIn) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  gradient:
                      new LinearGradient(colors: [MyColors.topGradient, MyColors.bottomGradient], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 1.0], tileMode: TileMode.clamp),
                ),
                child: getIfNameLoaded(explainName)),
          ),
          NextStep(
            toWhere: "Next question",
            function: gameProvider.goToNextStep,
          ),
        ],
      );
    }
    return getIfNameLoaded(explainName);
  }

  Widget getIfNameLoaded(String explainName) {
    if (explainName == "" || explainName == null) {
      return loadingName();
    } else {
      return showName();
    }
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    return Container(
      child: getresultWrapper(explainName, gameProvider),
    );
  }
}
