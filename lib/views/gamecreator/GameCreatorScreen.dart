import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/gameHistory.dart';
import 'package:xplain/viewModels/gameHistoryProvider.dart';
import 'package:xplain/viewModels/questionProvider.dart';
import 'package:xplain/views/gamecreator/getCodeScreen.dart';
import 'package:xplain/views/gamecreator/questionCard.dart';

import '../../myColors.dart';
import 'addQuestion.dart';
import 'gamesHistory.dart';

class GameCreator extends StatefulWidget {
  @override
  _GameCreatorState createState() => _GameCreatorState();
}

class _GameCreatorState extends State<GameCreator> {
  TextEditingController gameName = new TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      QuestionProvider questionProvider = Provider.of<QuestionProvider>(context);
      questionProvider.loadQuestionsFromDB();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    QuestionProvider questionProvider = Provider.of<QuestionProvider>(context);
    GameHistoryProvider gameHistoryProvider = Provider.of<GameHistoryProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [MyColors.topGradient, MyColors.bottomGradient], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 1.0], tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create Game",
                    style: TextStyle(color: MyColors.yellow, fontSize: 32, fontFamily: 'Hobo'),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GamesHistoryScreen()),
                        );
                      })
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Name:",
                style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Hand'),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: gameName,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Questions:",
                    style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Hand'),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    elevation: 0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: MyColors.yellow, width: 3)),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      startGame(questionProvider, gameHistoryProvider, _scaffoldKey);
                    },
                    child: Text(
                      "Publish",
                      style: TextStyle(fontSize: 21, color: MyColors.yellow, fontFamily: 'Hobo'),
                    ),
                  ),
                ],
              ),
              if (questionProvider.questions.length == 0)
                Expanded(
                    child: Center(
                  child: Text(
                    "Your game has no questions",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyColors.yellow, fontFamily: 'Hobo', fontSize: 40),
                  ),
                )),
              if (questionProvider.questions.length > 0)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: questionProvider.questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        background: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        key: Key(questionProvider.questions[index].id),
                        onDismissed: (direction) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          questionProvider.removeQuestion(questionProvider.questions[index].id);
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("question ${index + 1} deleted")));
                        },
                        child: QuestionCard(
                          questionProvider.questions[index],
                          Key(
                            index.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blue,
        heroTag: "save",
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          if (questionProvider.questions.length < 30) {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              backgroundColor: MyColors.bottomGradient,
              context: context,
              builder: (BuildContext bc) {
                return AddQuestion(
                  finishAdd,
                  null,
                );
              },
            );
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("up to 30 questions!")));
          }
        },
        child: Icon(
          Icons.add,
          color: MyColors.yellow,
        ),
      ),
    );
  }

  void startGame(QuestionProvider questionProvider, GameHistoryProvider gameHistoryProvider, GlobalKey<ScaffoldState> key) async {
    if (gameName.text == null || gameName.text.trim() == "") {
      key.currentState.showSnackBar(SnackBar(content: Text("No name No Game!")));
      return;
    } else if (questionProvider.questions.length == 0) {
      key.currentState.showSnackBar(SnackBar(content: Text("What's a game without Questions?")));
      return;
    } else if (questionProvider.questions.length > 30) {
      key.currentState.showSnackBar(SnackBar(content: Text("up to 30 questions!")));
    }
    bool cancreategame = await questionProvider.canCreateGame();
    if (!cancreategame) {
      key.currentState.showSnackBar(SnackBar(content: Text("Only 5 games a day!")));
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        DocumentReference ref;
        bool startloading = false;
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                  gradient: new RadialGradient(colors: [MyColors.bottomGradient, MyColors.topGradient], stops: [0.0, 1.0], tileMode: TileMode.clamp),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          startloading == false ? "Publishing Game" : "creating game...",
                          style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: 'Hobo'),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        if (startloading == false) Spacer(),
                        if (startloading == false)
                          Text(
                            'Are You Sure?',
                            style: TextStyle(fontSize: 40, color: MyColors.yellow, fontFamily: 'Hand'),
                          ),
                        Spacer(),
                        Row(
                          children: [
                            if (!startloading)
                              FlatButton(
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "cancel",
                                  style: TextStyle(fontSize: 22, color: MyColors.yellow, fontFamily: 'Hand'),
                                ),
                              ),
                            Spacer(),
                            if (!startloading)
                              FlatButton(
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  if (ref != null) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  setState(() {
                                    startloading = true;
                                  });
                                  ref = await FirebaseFirestore.instance.collection("games").add({
                                    'show': false,
                                    'name': gameName.text,
                                    'xplainName': "",
                                    'questionsCount': questionProvider.questions.length,
                                    'currentQuestion': 0,
                                    'gameStatus': 'START',
                                    'createdAt': Timestamp.now()
                                  });
                                  questionProvider.updateCreateCount();
                                  gameHistoryProvider.addGameHistory(GameHistory(
                                    createdAt: DateTime.now(),
                                    gameID: ref.id,
                                    gameName: gameName.text,
                                  ));
                                  List<Future> createQuestions = [];
                                  for (var question in questionProvider.questions) {
                                    createQuestions.add(FirebaseFirestore.instance.collection("questions").add({
                                      'gameID': ref.id,
                                      'index': question.index,
                                      'name': question.question,
                                      'no': question.noExplain,
                                      'yes': question.yesExplain,
                                      'idIndex': ref.id + "_" + question.index.toString(),
                                    }));
                                  }
                                  await Future.wait(createQuestions);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => GetCodeScreen(ref.id)),
                                  );
                                },
                                child: Text(
                                  "yes",
                                  style: TextStyle(fontSize: 22, color: MyColors.yellow, fontFamily: 'Hand'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (startloading)
                    SizedBox(
                      height: 350,
                      width: 350,
                      child: FlareActor("assets/bounce.flr", alignment: Alignment.center, fit: BoxFit.contain, animation: "Untitled"),
                    )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    gameName.dispose();
    super.dispose();
  }

  void finishAdd() {
    Navigator.pop(context);
  }
}
