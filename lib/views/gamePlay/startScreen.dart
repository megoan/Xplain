import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/viewModels/gameProvider.dart';

import '../../myColors.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [MyColors.topGradient, MyColors.bottomGradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      alignment: Alignment.center,
      child:gameProvider.creatorLoggedIn?
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Start game!",  style: TextStyle(
                fontFamily: 'Hobo', color: Colors.white, fontSize: 40),),
            SizedBox(height:60),
            Transform.scale(scale:2,child: FloatingActionButton(
              backgroundColor: MyColors.blue,
              onPressed: (){
                gameProvider.goToNextStep();
              },child:Icon(Icons.play_arrow, color: MyColors.yellow,))),
          ],
        ),
      ):
       Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            gameProvider.myGame.name,
            style: TextStyle(
                fontFamily: 'Hobo', color: Colors.white, fontSize: 40),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "will start in a moment!",
            style: TextStyle(
                fontFamily: 'Hobo', color: Colors.white, fontSize: 20),
          ),
          Container(
            width: width,
            height: width,
            child: FlareActor("assets/bounce.flr",
                alignment: Alignment.center,
                //fit: BoxFit.contain,
                animation: "Untitled"),
          )
        ],
      ),
    );
  }
}
