import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/question.dart';
import 'package:xplain/myColors.dart';
import 'package:xplain/viewModels/questionProvider.dart';

import 'addQuestion.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  //final GlobalKey<ScaffoldState> _scaffoldKey;
  QuestionCard(
    this.question,
    Key key,
  ) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    QuestionProvider questionProvider = Provider.of<QuestionProvider>(context);
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              backgroundColor: MyColors.bottomGradient,
              context: context,
              builder: (BuildContext bc) {
                return AddQuestion(
                  () {
                    Navigator.pop(context);
                  },
                  question,
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    alignment: Alignment.center,
                    //width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: new RadialGradient(
                            colors: [MyColors.orange, MyColors.orange],
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        border: Border.all(color: Colors.white, width: 4),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        (question.index + 1).toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: "Hobo"),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: width * 0.45,
                          child: Text(
                            question.question,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: "Xplain: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        text: (question.yesExplain
                                                ? "YES "
                                                : "") +
                                            (question.noExplain ? "NO" : "")),
                                  ]),
                            ),
                          ]),
                    ]),
                // Spacer(),
                Container(
                  child: Row(children: <Widget>[
                    IconButton(
                      onPressed: () {
                        questionProvider.swapIndexes(
                            question.index, question.index + 1);
                      },
                      icon: Icon(
                        Icons.arrow_downward,
                        color: MyColors.yellow,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        questionProvider.swapIndexes(
                            question.index, question.index - 1);
                      },
                      icon: Icon(
                        Icons.arrow_upward,
                        color: MyColors.yellow,
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
