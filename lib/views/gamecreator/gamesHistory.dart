import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/viewModels/gameHistoryProvider.dart';
import 'package:xplain/views/gamecreator/gameHistoryCard.dart';

import '../../myColors.dart';

class GamesHistoryScreen extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    GameHistoryProvider gameHistoryProvider = Provider.of<GameHistoryProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [MyColors.topGradient, MyColors.bottomGradient],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "My open Games",
                style: TextStyle(
                    color: MyColors.yellow, fontSize: 32, fontFamily: 'Hobo'),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: gameHistoryProvider.loadGameHistoriesFromDB(),
                builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.hasData && snapshot.data.length == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text("no games!",style: TextStyle(fontSize: 24,color: Colors.white,fontFamily: 'Hobo'),),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data.length > 0) {
                  List rev = snapshot.data.reversed.toList();
                  return Expanded(
                      child: ListView.separated(
                       
                        separatorBuilder: (context,index){
                          return SizedBox(height:8);
                        },
                        itemCount:rev.length,
                        itemBuilder: (context, index) {
                    return GameHistoryCard(rev[index],_scaffoldKey);
                  }));
                }
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
