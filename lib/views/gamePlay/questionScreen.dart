import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/question.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/views/gamePlay/waitingScreen.dart';
import 'package:xplain/views/gamecreator/nextStep.dart';

import '../../myColors.dart';

class QuestionScreen extends StatelessWidget {
  final List<bool> selectedArr = [false, false];
  Widget gwtQuestionWrapper(AsyncSnapshot<QuerySnapshot> snapshot,GameProvider gameProvider,BuildContext context){
     if (gameProvider.creatorLoggedIn) {
        return Column(
          children: [
            Expanded(child: getQuestion(snapshot,gameProvider,context)),
            NextStep(toWhere: "View answers",function: gameProvider.setWaitingForAnswers,),
          ],
        );
      }
    return getQuestion(snapshot,gameProvider,context);
  }
  Widget getQuestion(AsyncSnapshot<QuerySnapshot> snapshot,GameProvider gameProvider,BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return WaitingScreens();
    } else if (snapshot.connectionState == ConnectionState.done) {
      return WaitingScreens();
    } else if (snapshot.hasError) {
      return Text("error");
    } else {
      Question question = Question.fromMap(snapshot.data.docs[0].data(), snapshot.data.docs[0].id);
          gameProvider.question=question.question;
      return Container(

        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [MyColors.topGradient, MyColors.bottomGradient],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Stack(
          children: [
            Align(child: 
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                      children: [
                        Material(
                          type: MaterialType
                              .transparency, //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedArr[0]
                                      ? MyColors.blue
                                      : MyColors.darkGrey,
                                  width: 4.0),
                              //color: MyColors.lightGrey,
                              gradient: new RadialGradient(
                                  colors: selectedArr[0]
                                      ? [MyColors.yellow, MyColors.orange]
                                      : [MyColors.lightGrey, MyColors.lightGrey],
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: gameProvider.creatorLoggedIn?null:() {
                               sendAnswer(gameProvider,true);
                              },
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(
                                  1000.0), //Something large to ensure a circle
                              //onTap: _messages,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Y",
                                  style: TextStyle(
                                      fontFamily: 'Hobo',
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        ),
                       Spacer(),
                        Material(
                          type: MaterialType
                              .transparency, //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedArr[1]
                                      ? MyColors.blue
                                      : MyColors.darkGrey,
                                  width: 4.0),
                              //color: MyColors.lightGrey,
                              gradient: new RadialGradient(
                                  colors: selectedArr[1]
                                      ? [MyColors.yellow, MyColors.orange]
                                      : [MyColors.lightGrey, MyColors.lightGrey],
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: gameProvider.creatorLoggedIn?null:() {
                              sendAnswer(gameProvider,false);
                              },
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(
                                  1000.0), //Something large to ensure a circle
                              //onTap: _messages,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "N",
                                  style: TextStyle(
                                      fontFamily: 'Hobo',
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            alignment: Alignment.bottomCenter,),
            Align(
              alignment: Alignment.topCenter,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50,left: 8,right: 8),
                              child: Text(question.question,
                               style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: 'Hobo'),
                              ),
                            ),
                // child: 
                // Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       Text(question.question),
                //       Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             ElavationButton(
                //               child: Text("yes"),
                //               onPressed: () {
                //                 selected = true;
                //               },
                //             ),
                //             ElavationButton(
                //               child: Text("no"),
                //               onPressed: () {
                //                 selected = false;
                //               },
                //             )
                //           ]),
                //       ElavationButton(
                //         onPressed: ()  {
                          

                //            FirebaseFirestore.instance
                //               .collection("answers")
                //               .add({
                //             'gameID': gameProvider.myGame.id,
                //             'answer': selected,
                //             'idIndex':gameProvider.myGame.id + "_" + gameProvider.myGame.currentQuestion.toString(),
                //             'name':"Shmil",
                //             'index':gameProvider.myGame.currentQuestion
                //           });
                //           gameProvider.setWaitingForAnswers();
                   
                //         },
                //         child: Text("send"),
                //       )
                //     ]),
              ),
            ),
          ],
        ),
      );
  
  
    }
  }
  void sendAnswer(GameProvider gameProvider,bool selected){
                   FirebaseFirestore.instance
                              .collection("answers")
                              .add({
                            'gameID': gameProvider.myGame.id,
                            'answer': selected,
                            'idIndex':gameProvider.myGame.id + "_" + gameProvider.myGame.currentQuestion.toString(),
                            'name':"Shmil",
                            'index':gameProvider.myGame.currentQuestion,
                            'skipMe':false,
                          });
                          gameProvider.setWaitingForAnswers();
  }
  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    
    String questionID = gameProvider.myGame.id + "_" +  gameProvider.myGame.currentQuestion.toString();
    print(questionID);
    // if (gameProvider.waitingForAnser) {
    //   return Container(alignment: Alignment.center,child: Text("waiting for answer"),);
    // }else
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("questions")
            .where("idIndex", isEqualTo: questionID)
            .snapshots(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: gwtQuestionWrapper(snapshot,gameProvider,context),
          );
        });
  }
}
