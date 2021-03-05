import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/game.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/views/gamePlay/answerScreen.dart';
import 'package:xplain/views/gamePlay/endScreen.dart';
import 'package:xplain/views/gamePlay/questionScreen.dart';
import 'package:xplain/views/gamePlay/startScreen.dart';
import 'package:xplain/views/gamePlay/waitingScreen.dart';
import 'package:xplain/views/gamePlay/xplainScrenn.dart';

class GameScreen extends StatelessWidget {
  final String gameID;
  GameScreen(this.gameID);

  Widget getGameStatus(Game game,bool waitingForAnser,bool creator) {
    print(game.gamestatus);
    switch (game.gamestatus) {
      case GAMESTATUS.START:
      return StartScreen();
        break;
      case GAMESTATUS.QUESTION:
           
      if(!waitingForAnser)return QuestionScreen();
      return AnswerScreen();
        break;
      case GAMESTATUS.ANSWER:
      return AnswerScreen();
        break;
      case GAMESTATUS.XPLAIN:
        return XplainScreen(game.explainName);
        break;
      case GAMESTATUS.END:
      return EndScreen();
        break;
      default:
      return WaitingScreens();
    }
  }

  Widget getGameStep(AsyncSnapshot<DocumentSnapshot> snapshot, GameProvider gameProvider) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return WaitingScreens();
    } else if (snapshot.connectionState == ConnectionState.done) {
      return WaitingScreens();
    } else if (snapshot.hasError) {
      return Text("error");
    } else {
     
       if (gameProvider.myGame!=null) {
        gameProvider.myGame.updateGame(snapshot.data.data());
      }
      else{
         gameProvider.myGame= Game.fromMap(snapshot.data.data());
      }
      gameProvider.myGame.id = snapshot.data.id;
      return getGameStatus(gameProvider.myGame,gameProvider.waitingForAnser,gameProvider.creatorLoggedIn);
    }
  }

  @override
  Widget build(BuildContext context) {
   GameProvider gameProvider = Provider.of<GameProvider>(context);
    return SafeArea(
          child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("games").doc(gameID)     
                .snapshots(),
            builder: (context, snapshot) {
             // print(snapshot.data);
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: getGameStep(snapshot,gameProvider),
              );
            }),
      ),
    );
  }
}
