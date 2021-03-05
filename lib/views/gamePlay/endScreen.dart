import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/viewModels/gameProvider.dart';

import '../../myColors.dart';

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    return Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [MyColors.topGradient, MyColors.bottomGradient],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(),
            Text(
              "Hope you had fun playing:",
              style: TextStyle(
                  fontFamily: 'Hobo', color: Colors.white, fontSize: 20),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "X",
                  style: TextStyle(
                      fontFamily: 'Hobo',
                      color: Colors.yellow.withOpacity(0.4),
                      fontSize: 230),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    gameProvider.myGame.name,
                    style: TextStyle(
                        fontFamily: 'Hobo', color: Colors.white, fontSize: 40),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "see you next time!",
                  style: TextStyle(
                      fontFamily: 'Hobo', color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            Container(
              width: 200,
              height: 200,
              child: FlareActor("assets/bounce.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Untitled"),
            ),
          ],
        ));
  }
}
