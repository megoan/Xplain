import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xplain/models/game.dart';

import '../../myColors.dart';

class CodesBottomScreen extends StatelessWidget {
  final Game game;
  CodesBottomScreen(this.game,);
   final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your code',
                  style: TextStyle(
                      color: MyColors.yellow, fontSize: 42, fontFamily: 'Hand'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(game.creatorCode
                      ,
                      style: TextStyle(
                          color: Colors.white, fontSize: 30, fontFamily: 'Hobo'),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.content_copy,
                          color: Colors.white,
                        ),
                        onPressed: () {
                           Clipboard.setData(new ClipboardData(text: game.creatorCode));
                          final snackBar =
                              SnackBar(content: Text(game.creatorCode+' copied to clipboard!'), behavior: SnackBarBehavior.floating,);

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Player's code",
                  style: TextStyle(
                      color: MyColors.yellow, fontSize: 42, fontFamily: 'Hand'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.gameEnterCode,
                      style: TextStyle(
                          color: Colors.white, fontSize: 30, fontFamily: 'Hobo'),
                    ),
                    IconButton(
                        icon: Icon(Icons.content_copy, color: Colors.white),
                        onPressed: 
                      () {
                        Clipboard.setData(new ClipboardData(text: game.gameEnterCode));
                          final snackBar =
                              SnackBar(content: Text( game.gameEnterCode+' copied to clipboard!'), behavior: SnackBarBehavior.floating,);

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        )
                  ],
                ),
              ],
            ),
      ),
    );
  }
}