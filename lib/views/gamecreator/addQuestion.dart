import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/question.dart';
import 'package:xplain/myColors.dart';
import 'package:xplain/viewModels/questionProvider.dart';

class AddQuestion extends StatefulWidget {
  final Function finishAddCallBack;
  final Question question;
  AddQuestion(
    this.finishAddCallBack,
    this.question,
  );
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  List<bool> selected = [false, false];
  TextEditingController questionText = new TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    if (widget.question != null) {
      questionText.text = widget.question.question;
      selected[0] = widget.question.yesExplain;
      selected[1] = widget.question.noExplain;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuestionProvider questionProvider = Provider.of<QuestionProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question:",
                  style: TextStyle(
                      color: Colors.white, fontSize: 30, fontFamily: 'Hand'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration:
                      InputDecoration(filled: true, fillColor: Colors.white),
                  controller: questionText,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "What answer should Xplain?",
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: 'Hand'),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Material(
                      type: MaterialType
                          .transparency, //Makes it usable on any background color, thanks @IanSmith
                      child: Ink(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selected[0]
                                  ? MyColors.blue
                                  : MyColors.darkGrey,
                              width: 4.0),
                          //color: MyColors.lightGrey,
                          gradient: new RadialGradient(
                              colors: selected[0]
                                  ? [MyColors.yellow, MyColors.orange]
                                  : [MyColors.lightGrey, MyColors.lightGrey],
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selected[0] = !selected[0];
                            });
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
                    SizedBox(width: 20),
                    Material(
                      type: MaterialType
                          .transparency, //Makes it usable on any background color, thanks @IanSmith
                      child: Ink(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selected[1]
                                  ? MyColors.blue
                                  : MyColors.darkGrey,
                              width: 4.0),
                          //color: MyColors.lightGrey,
                          gradient: new RadialGradient(
                              colors: selected[1]
                                  ? [MyColors.yellow, MyColors.orange]
                                  : [MyColors.lightGrey, MyColors.lightGrey],
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selected[1] = !selected[1];
                            });
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

                // ToggleButtons(
                //   children: [Text("yes"), Text("no")],
                //   isSelected: selected,
                //   onPressed: (index) {
                //     setState(() {
                //       selected[index] = !selected[index];
                //     });
                //   },
                // ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: MyColors.yellow, width: 3),
                      ),
                      color: MyColors.topGradient,
                      onPressed: () {
                        if (questionText.text == null ||
                            questionText.text.trim() == "") {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Question! Question!"),
                            behavior: SnackBarBehavior.floating,
                          ));
                          return;
                        }
                        if (widget.question == null) {
                          addQuestion(questionProvider);
                        } else {
                          updateQuestion(questionProvider);
                        }
                      },
                      child: Text(
                        widget.question == null
                            ? "Add Question"
                            : "Update Question",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Hobo',
                            fontSize: 25),
                      )),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  void addQuestion(QuestionProvider questionProvider)async {
    bool addSucces =await questionProvider.addQuestion(new Question(
        id: questionProvider.questions.length.toString(),
        index: questionProvider.questions.length,
        question: questionText.text.toString(),
        yesExplain: selected[0],
        noExplain: selected[1]));
    if (addSucces) {
      widget.finishAddCallBack();
    }
  }

  void updateQuestion(QuestionProvider questionProvider) {
    bool updateSucces = questionProvider.updateQuestion(new Question(
        dbID: widget.question.dbID,
        id: widget.question.id,
        index: widget.question.index,
        question: questionText.text.toString(),
        yesExplain: selected[0],
        noExplain: selected[1]));
    if (updateSucces) {
      widget.finishAddCallBack();
    }
  }

  @override
  void dispose() {
    questionText.dispose();
    super.dispose();
  }
}
