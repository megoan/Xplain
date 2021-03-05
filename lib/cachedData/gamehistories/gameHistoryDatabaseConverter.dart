

import 'package:xplain/cachedData/gamehistories/gameHistoryDatabaseHelper.dart';
import 'package:xplain/models/gameHistory.dart';

class GameHistoryDatabaseConverter {
  static GameHistory convertDBtoGameHistory(Map<String, dynamic> row) {
    if (row != null) {
      return GameHistory(
          gameID: row[GHDatabaseHelper.columnGameID].toString(),
          dbID: row[GHDatabaseHelper.columnId],
          gameName: row[GHDatabaseHelper.columnGameName],
          createdAt:DateTime.parse(row[GHDatabaseHelper.columnCreatedAt]));
    }
    return null;
  }

  static Map<String, dynamic> convertGameHistoryToDB(GameHistory gameHistory) {
    if (gameHistory != null) {
      Map<String, dynamic> row = {};
      if (gameHistory.dbID != null) {
        row[GHDatabaseHelper.columnId] = gameHistory.dbID;
      }
      row[GHDatabaseHelper.columnGameID] = gameHistory.gameID;
      row[GHDatabaseHelper.columnGameName] = gameHistory.gameName;
      row[GHDatabaseHelper.columnCreatedAt] = gameHistory.createdAt.toIso8601String();
      return row;
    }
    return null;
  }
}
