import 'package:xplain/models/question.dart';

enum GAMEUSER { PLAYER, CREATOR }
enum GAMESTATUS { START, QUESTION, ANSWER, XPLAIN, END }

class Game {
  String id;
  String name;
  List<Question> questions;
  String gameEnterCode;
  String creatorCode;
  GAMEUSER userType;
  GAMESTATUS gamestatus;
  int currentQuestion;
  String question;
  String explainName;
  bool show;
  Game(
      {this.id,
      this.name,
      this.questions,
      this.creatorCode,
      this.gameEnterCode,
      this.gamestatus = GAMESTATUS.START,
      this.currentQuestion = -1,
      this.explainName,
      this.show});

  Game.fromMap(Map data) {
    print(GAMESTATUS.values.firstWhere((element) =>
        element.toString().split(".")[1].toString().toLowerCase() ==
        data['gameStatus'].toString().toLowerCase()));
    creatorCode = data['creatorCode'];
    gameEnterCode = data['enterCode'];
    id = data['gameID'];
    name = data['name'] ?? '';
    gamestatus = GAMESTATUS.values.firstWhere((element) =>
            element.toString().split(".")[1].toString().toLowerCase() ==
            data['gameStatus'].toString().toLowerCase()) ??
        GAMESTATUS.START;
    currentQuestion = data['currentQuestion'] ?? '';
    explainName = data['xplainName'] ?? '';
    show = data['show'] ?? false;
  }

  void updateGame(Map data) {
    print(GAMESTATUS.values.firstWhere((element) =>
        element.toString().split(".")[1].toString().toLowerCase() ==
        data['gameStatus'].toString().toLowerCase()));
    creatorCode = data['creatorCode'];
    gameEnterCode = data['enterCode'];
    id = data['gameID'];
    name = data['name'] ?? '';
    gamestatus = GAMESTATUS.values.firstWhere((element) =>
            element.toString().split(".")[1].toString().toLowerCase() ==
            data['gameStatus'].toString().toLowerCase()) ??
        GAMESTATUS.START;
    currentQuestion = data['currentQuestion'] ?? '';
    explainName = data['xplainName'] ?? '';
    show = data['show'] ?? false;
  }
}
