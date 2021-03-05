import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../myColors.dart';

class WaitingScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return  Container(
           decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [MyColors.topGradient, MyColors.bottomGradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
        child: SizedBox(
  height: double.infinity,
  width: double.infinity,
  child: FlareActor("assets/bounce.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: "Untitled"),
),
      );
  }
}