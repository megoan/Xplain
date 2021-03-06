import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xplain/models/game.dart';

import '../../myColors.dart';

class CodeScreen extends StatelessWidget {
  final Game game;
  CodeScreen(this.game);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [MyColors.topGradient, MyColors.bottomGradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(),
          Text(
            'Game Online',
            style: TextStyle(
                color: Colors.white, fontSize: 32, fontFamily: 'Hobo'),
          ),
          Column(
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
                            SnackBar(content: Text(game.creatorCode+' copied to clipboard!'));

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
                            SnackBar(content: Text( game.gameEnterCode+' copied to clipboard!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      )
                ],
              ),
            ],
          ),
          SizedBox(),
          ElevatedButton(
          
            onPressed: () {},
            child: Text(
              "Play",
              style: TextStyle(
                  fontSize: 31, color: MyColors.yellow, fontFamily: 'Hobo'),
            ),
          ),
        ],
      ),
    );
  }
}
