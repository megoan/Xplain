import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/answer.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/views/gamePlay/waitingScreen.dart';
import 'package:xplain/views/gamecreator/nextStep.dart';

import '../../myColors.dart';

class AnswerScreen extends StatelessWidget {
  Widget answersWidget(GameProvider gameProvider, int yes, int no) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(colors: [MyColors.topGradient, MyColors.bottomGradient], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 1.0], tileMode: TileMode.clamp),
      ),
      child: Stack(
        children: [
          LayoutBuilder(builder: (context, BoxConstraints constraints) {
            print(constraints.maxHeight);
            return Align(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          yes.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Hobo'),
                        ),
                        Container(
                          width: 12,
                          height: (yes > 0 || no > 0) ? constraints.maxHeight / 2 * (yes / (yes + no)) : 0,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            gradient: new LinearGradient(
                                colors: [
                                  MyColors.orange,
                                  MyColors.yellow,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency, //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.blue, width: 4.0),
                              //color: MyColors.lightGrey,
                              gradient: new RadialGradient(colors: [MyColors.yellow, MyColors.orange], stops: [0.0, 1.0], tileMode: TileMode.clamp),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Y",
                                style: TextStyle(fontFamily: 'Hobo', color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          no.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Hobo'),
                        ),
                        Container(
                          width: 12,
                          height: (yes > 0 || no > 0) ? constraints.maxHeight / 2 * (no / (yes + no)) : 0,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            gradient: new LinearGradient(
                                colors: [
                                  MyColors.orange,
                                  MyColors.yellow,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency, //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.blue, width: 4.0),
                              //color: MyColors.lightGrey,
                              gradient: new RadialGradient(colors: [MyColors.yellow, MyColors.orange], stops: [0.0, 1.0], tileMode: TileMode.clamp),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "N",
                                style: TextStyle(fontFamily: 'Hobo', color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              alignment: Alignment.bottomCenter,
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
                child: Text(
                  gameProvider.question,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Hobo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getQuestion(AsyncSnapshot<QuerySnapshot> snapshot, GameProvider gameProvider) {
    int yes = 0;
    int no = 0;
    if (snapshot.connectionState == ConnectionState.waiting) {
      return WaitingScreens();
    } else if (snapshot.connectionState == ConnectionState.done) {
      return WaitingScreens();
    } else if (snapshot.hasError) {
      return Text("error");
    } else {
      //snapshot.data.docs[0].data()
      for (var item in snapshot.data.docs) {
        Answer answer = Answer.fromMap(item.data(), item.id);
        if (answer.answer) {
          yes++;
        } else {
          no++;
        }
      }
      if (gameProvider.creatorLoggedIn) {
        return Column(
          children: [
            Expanded(child: answersWidget(gameProvider, yes, no)),
            NextStep(
              toWhere: "xplain",
              function: gameProvider.goToNextStep,
            ),
          ],
        );
      }
      return answersWidget(gameProvider, yes, no);
    }
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    //gameProvider.waitingForAnser = false;
    String answerID = gameProvider.myGame.id + "_" + gameProvider.myGame.currentQuestion.toString();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("answers").where("idIndex", isEqualTo: answerID).snapshots(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: getQuestion(snapshot, gameProvider),
          );
        });
  }
}
