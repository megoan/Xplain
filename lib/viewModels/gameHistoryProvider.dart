import 'package:flutter/material.dart';
import 'package:xplain/cachedData/gameHistories/gameHistoryDatabaseHelper.dart';
import 'package:xplain/models/gameHistory.dart';

class GameHistoryProvider extends  ChangeNotifier {
  List<GameHistory>gameHistories=[];

  void addGameHistory(GameHistory gameHistory)async{
    gameHistories.add(gameHistory);
    final dbHelper = GHDatabaseHelper.instance;
    int dbID = await dbHelper.insert(gameHistory);
    gameHistories[gameHistories.length-1].dbID=dbID;
    //notifyListeners();
  }

  void removeGameHistory(GameHistory gameHistory)async{
    gameHistories.removeWhere((game) => game.gameID==gameHistory.gameID);
    final dbHelper = GHDatabaseHelper.instance;
    await dbHelper.delete(gameHistory);
    notifyListeners();

  }

  Future<List<GameHistory>>loadGameHistoriesFromDB()async{
    final dbHelper = GHDatabaseHelper.instance;
    gameHistories = await dbHelper.queryAllRows();
    return gameHistories;
  }
  
}