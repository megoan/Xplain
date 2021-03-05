import 'package:xplain/cachedData/questions/questionDatabaseHelper.dart';
import 'package:xplain/models/question.dart';

class QuestionDatabaseConverter {
  static Question convertDBtoQuestion(Map<String, dynamic> row) {
    if (row != null) {
      return Question(
          id: row[QDatabaseHelper.columnIndex].toString(),
          dbID: row[QDatabaseHelper.columnId],
          index: row[QDatabaseHelper.columnIndex],
          yesExplain: row[QDatabaseHelper.columnExplainYes] == "1",
          noExplain: row[QDatabaseHelper.columnExplainNo] == "1",
          question: row[QDatabaseHelper.columnQuestion]);
    }
    return null;
  }

  static Map<String, dynamic> convertQuestionToDB(Question question) {
    if (question != null) {
      Map<String, dynamic> row = {};
      if (question.dbID != null) {
        row[QDatabaseHelper.columnId] = question.dbID;
      }
      row[QDatabaseHelper.columnIndex] = question.index;
      row[QDatabaseHelper.columnExplainYes] = question.yesExplain ? "1" : "0";
      row[QDatabaseHelper.columnExplainNo] = question.noExplain ? "1" : "0";
      row[QDatabaseHelper.columnQuestion] = question.question;
      return row;
    }
    return null;
  }
}
