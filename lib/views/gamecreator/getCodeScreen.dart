import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/game.dart';
import 'package:xplain/viewModels/gameHistoryProvider.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/views/gamePlay/waitingScreen.dart';
import 'package:xplain/views/gamecreator/codeScreen.dart';

class GetCodeScreen extends StatelessWidget {
  final String gameID;
  GetCodeScreen(this.gameID);

  Widget getGameStatus(Game game,GameHistoryProvider gameHistoryProvider) {
    if (game.creatorCode!=null && game.creatorCode!='') {
      return CodeScreen(game);
    }
    else{
        return WaitingScreens();
    }
  
  }

  Widget getGameStep(AsyncSnapshot<DocumentSnapshot> snapshot, GameProvider gameProvider,GameHistoryProvider gameHistoryProvider) {
    if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.done) {
      return WaitingScreens();
    }  else if (snapshot.hasError) {
      return Text("error");
    } else {
     
      if (gameProvider.myGame!=null) {
        gameProvider.myGame.updateGame(snapshot.data.data());
      }
      else{
         gameProvider.myGame= Game.fromMap(snapshot.data.data());
      }
      gameProvider.myGame.id = snapshot.data.id;
      print(gameProvider.myGame);
      return getGameStatus(gameProvider.myGame,gameHistoryProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
   GameProvider gameProvider = Provider.of<GameProvider>(context);
   GameHistoryProvider gameHistoryProvider=Provider.of<GameHistoryProvider>(context);
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("games")
              .doc(gameID)
              .snapshots(),
          builder: (context, snapshot) {
            print(snapshot.data);
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: getGameStep(snapshot,gameProvider,gameHistoryProvider),
            );
          }),
    );
  }
}
