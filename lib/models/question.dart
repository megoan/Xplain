class Question {
  String id;
  int dbID;
  int index;
  String question;
  bool yesExplain;
  bool noExplain;
  Question({this.id,this.index,this.yesExplain,this.noExplain,this.question,this.dbID});

   Question.fromMap(Map data,String id) {
    this.id=id;
    question = data['name'] ?? '';
    yesExplain = data['yes'] ?? '';
    noExplain = data['no'] ?? '';
    index = data['index'] ?? '';
  }
}