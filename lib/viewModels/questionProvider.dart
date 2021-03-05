import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplain/cachedData/questions/questionDatabaseHelper.dart';
import 'package:xplain/models/question.dart';

class QuestionProvider extends ChangeNotifier {
  List<Question> questions = [];

  Future<bool> addQuestion(Question question) async{
    questions.add(question);
    final dbHelper = QDatabaseHelper.instance;
    int dbID = await dbHelper.insert(question);
    questions[questions.length-1].dbID=dbID;
    notifyListeners();
    return true;
  }

  void removeQuestion(String id) {
    int selected = 0;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].id==id) {
        selected=i;
      }
    }
    final dbHelper = QDatabaseHelper.instance;
    dbHelper.delete(questions[selected]);
    questions.removeAt(selected);
    resetIndexes();
  }

  bool updateQuestion(Question question) {
    int index = questions.indexWhere((element) => element.id == question.id);
    if (index != -1) {
      questions[index] = question;
    }
    final dbHelper = QDatabaseHelper.instance;
    dbHelper.update(questions[index]);
    notifyListeners();
    return true;
  }

  void sortQuestions() {
    questions.sort((a, b) => a.index.compareTo(b.index));
  }

  void resetIndexes() {
    for (var i = 0; i < questions.length; i++) {
      questions[i].index = i;
      final dbHelper = QDatabaseHelper.instance;
      dbHelper.update(questions[i]);
    }
    notifyListeners();
  }

  void swapPlaces(String id1, String id2) {
    int index1 = questions.indexWhere((element) => element.id == id1);
    int index2 = questions.indexWhere((element) => element.id == id2);
    if (index1 != -1 && index2 != -1) {
      int temp = questions[index1].index;
      questions[index1].index = questions[index2].index;
      questions[index2].index = temp;

      final dbHelper = QDatabaseHelper.instance;
      dbHelper.update(questions[index1]);
      dbHelper.update(questions[index2]);

      notifyListeners();
    }
  }

  void swapIndexes(int id1, int id2) {
    if (id1 >= 0 &&
        id2 >= 0 &&
        id1 < questions.length &&
        id2 < questions.length) {
      int temp = questions[id1].index;
      questions[id1].index = questions[id2].index;
      questions[id2].index = temp;
      
      final dbHelper = QDatabaseHelper.instance;
      dbHelper.update(questions[id1]);
      dbHelper.update(questions[id2]);
      sortQuestions();
      notifyListeners();
    }
  }
   static bool isSameDate(DateTime d1,DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month
           && d1.day == d2.day;
  }

  Future<void>loadQuestionsFromDB()async{
    final dbHelper = QDatabaseHelper.instance;
    questions = await dbHelper.queryAllRows();
    notifyListeners();
  }
     Future<bool> canCreateGame() async {
     Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int counter = (prefs.getInt('GamesCreatedToday') ?? 0);
    final String date = (prefs.getString('GamesCreatedTodayDate'));
    if (date==null) {
      return true;
    }
    else if (counter<5 ) {
        return true;
      }
      else if(counter>=5 ){
        if (date!=null && isSameDate(DateTime.now(),DateTime.parse(date))) {
          return false;
        }
        else{
          return true;
        }
      }
      return true;
  }
  Future<bool>updateCreateCount()async{
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int counter = (prefs.getInt('GamesCreatedToday') ?? 0);
    final String date = (prefs.getString('GamesCreatedTodayDate'));
    if (date==null) {
      prefs.setInt("GamesCreatedToday", 1);
      prefs.setString("GamesCreatedTodayDate", DateTime.now().toIso8601String());
      return true;
    }
    else if (counter<5 ) {
        if (date!=null &&isSameDate(DateTime.now(),DateTime.parse(date))) {
          prefs.setInt("GamesCreatedToday", ++counter);
          return true;
        }
        else{
          prefs.setInt("GamesCreatedToday", 1);
          prefs.setString("GamesCreatedTodayDate", DateTime.now().toIso8601String());
          return true;
        }
      }
      else if(counter>=5 ){
        if (date!=null && isSameDate(DateTime.now(),DateTime.parse(date))) {
          return false;
        }
        else{
          prefs.setInt("GamesCreatedToday", 1);
          prefs.setString("GamesCreatedTodayDate", DateTime.now().toIso8601String());
          return true;
        }
      }
      prefs.setInt("GamesCreatedToday", 1);
      prefs.setString("GamesCreatedTodayDate", DateTime.now().toIso8601String());
      return true;
  }
}
