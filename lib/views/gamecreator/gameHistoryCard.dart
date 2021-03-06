import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/models/gameHistory.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/viewModels/questionProvider.dart';

import '../../myColors.dart';
import 'codesBottomScreen.dart';

class GameHistoryCard extends StatelessWidget {
  final GameHistory gameHistory;
  GameHistoryCard(this.gameHistory);
  String getTimeAsString(DateTime date) {
    if (QuestionProvider.isSameDate(DateTime.now(), date)) {
      //get time
      return "${date.hour < 10 ? ('0' + date.hour.toString()) : date.hour}:${date.minute < 10 ? ('0' + date.minute.toString()) : date.minute}";
    } else {
      //get date
      return "${date.day < 10 ? ('0' + date.day.toString()) : date.day}/${date.month < 10 ? ('0' + date.month.toString()) : date.month}}/${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          gradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gameHistory.gameName,
              style: TextStyle(color: Colors.white, fontFamily: 'Hobo', fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              getTimeAsString(gameHistory.createdAt),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    gameProvider.getGameByID(gameHistory.gameID).then((game) {
                      if (game != null) {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            ),
                            backgroundColor: MyColors.bottomGradient,
                            context: context,
                            builder: (BuildContext bc) {
                              return CodesBottomScreen(game);
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Game is no more..."),
                          ),
                        );
                      }
                    });
                  },
                  icon: Icon(
                    Icons.content_copy,
                    color: Colors.white,
                  ),
                  label: Text(
                    "GET CODES",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
