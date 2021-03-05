class Answer {
  bool answer;
  String id;
  bool skipMe;
  String name;
  Answer({this.answer,this.name,this.skipMe});

   Answer.fromMap(Map data,String id) {
     this.id=id;
    answer = data['answer'] ?? false;
    name = data['name'] ?? '';
    skipMe = data['skipMe'] ?? false;
  }
}