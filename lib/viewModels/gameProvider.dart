import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xplain/models/answer.dart';
import 'package:xplain/models/game.dart';
import 'package:xplain/models/question.dart';

class GameProvider extends ChangeNotifier {
  List<Game> games = [];
  bool waitingForAnser = false;
  String question = "";
  String myName;
  Game myGame;
  bool lookingForGame = false;
  bool creatorLoggedIn = false;
  var rng = new Random();
  bool addGame(Game game) {
    games.add(game);
    notifyListeners();
    return true;
  }

  void setWaitingForAnswers() {
    waitingForAnser = true;
    notifyListeners();
  }

  Future<String> getGame(String code, String name) async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("games").where("enterCode", isEqualTo: code).get();
    if (snap.docs.length > 0) {
      creatorLoggedIn = false;
      myName = name;
      myGame = Game.fromMap(snap.docs[0].data());
      return snap.docs[0].id;
    } else {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection("games").where("creatorCode", isEqualTo: code).get();
      creatorLoggedIn = true;
      if (snap.docs.length > 0) {
        creatorLoggedIn = true;
        myName = name;
        QuerySnapshot questionSnap = await FirebaseFirestore.instance.collection("questions").where("gameID", isEqualTo: snap.docs[0].id).get();
        myGame = Game.fromMap(snap.docs[0].data());
        myGame.questions = [];
        for (var question in questionSnap.docs) {
          myGame.questions.add(Question.fromMap(question.data(), question.id));
        }
        notifyListeners();
        return snap.docs[0].id;
      }
    }
    return "-1";
  }

  Future<Game> getGameByID(String id) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("games").doc(id).get();
    if (snap != null) {
      return Game.fromMap(snap.data());
    }
    return null;
  }

  startLooking() {
    lookingForGame = true;
    notifyListeners();
  }

  stopLooking() {
    lookingForGame = false;
    notifyListeners();
  }

  Future<void> goToNextStep() async {
    var ref = FirebaseFirestore.instance.collection("games");
    switch (myGame.gamestatus) {
      case GAMESTATUS.START:
        ref
            .doc(myGame.id)
            .update({
              'gameStatus': 'QUESTION',
            })
            .then((value) => print("Game Updated"))
            .catchError((error) => print("Failed to update user: $error"));

        break;
      case GAMESTATUS.QUESTION:
        ref
            .doc(myGame.id)
            .update({
              'gameStatus': 'XPLAIN',
            })
            .then((value) => print("Game Updated"))
            .catchError((error) => print("Failed to update user: $error"));
        String answerID = myGame.id + "_" + myGame.currentQuestion.toString();
        QuerySnapshot answerSnap = await FirebaseFirestore.instance.collection("answers").where("idIndex", isEqualTo: answerID).get();
        List<String> names = [];
        for (var ans in answerSnap.docs) {
          Answer answer = Answer.fromMap(ans.data(), ans.id);
          if (myGame.questions[myGame.currentQuestion].yesExplain && answer.answer) {
            names.add(answer.name);
          } else if (myGame.questions[myGame.currentQuestion].noExplain && !answer.answer) {
            names.add(answer.name);
          }
        }
        if (names.length > 0) {
          int picked = rng.nextInt(names.length);
          String chodenName = names[picked];
          ref
              .doc(myGame.id)
              .update({
                'xplainName': chodenName,
              })
              .then((value) => print("Game Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        } else {
          ref
              .doc(myGame.id)
              .update({
                'xplainName': "NOBODY",
              })
              .then((value) => print("Game Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        }
        break;
      case GAMESTATUS.ANSWER:
        ref
            .doc(myGame.id)
            .update({
              'gameStatus': 'XPLAIN',
            })
            .then((value) => print("Game Updated"))
            .catchError((error) => print("Failed to update user: $error"));
        break;
      case GAMESTATUS.XPLAIN:
        if ((myGame.currentQuestion + 1) == myGame.questions.length) {
          ref
              .doc(myGame.id)
              .update({
                'gameStatus': 'END',
              })
              .then((value) => print("Game Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        } else {
          ref
              .doc(myGame.id)
              .update({'gameStatus': 'QUESTION', 'xplainName': "", 'currentQuestion': ++myGame.currentQuestion})
              .then((value) => print("Game Updated"))
              .catchError((error) => print("Failed to update user: $error"));
          waitingForAnser = false;
          notifyListeners();
        }

        break;
      case GAMESTATUS.END:
        // no steps after this...
        break;
      default:
    }
  }
}
