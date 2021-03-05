
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xplain/myColors.dart';
import 'package:xplain/viewModels/gameHistoryProvider.dart';
import 'package:xplain/viewModels/gameProvider.dart';
import 'package:xplain/viewModels/questionProvider.dart';
import 'package:xplain/views/gamePlay/GameScreen.dart';

import 'views/gamecreator/GameCreatorScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => QuestionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameHistoryProvider(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          title: 'X-plain',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController code = new TextEditingController();
  TextEditingController name = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [MyColors.topGradient, MyColors.bottomGradient],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(),
                RichText(
                  text: TextSpan(style: TextStyle(fontSize: 84), children: [
                    TextSpan(
                      text: 'X',
                      style:
                          TextStyle(color: MyColors.yellow, fontFamily: 'Hobo'),
                    ),
                    TextSpan(
                      text: 'plain',
                      style: TextStyle(color: Colors.white, fontFamily: 'Hobo'),
                    ),
                  ]),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          TextField(
                            autofocus: false,
                            style: TextStyle(fontSize: 30),
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(50.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: MyColors.topGradient,
                                    fontFamily: 'Hand'),
                                hintText: "Game code",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                fillColor: MyColors.yellow),
                            controller: code,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            autofocus: false,
                            style: TextStyle(fontSize: 30),
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(50.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: MyColors.topGradient,
                                    fontFamily: 'Hand'),
                                hintText: "your name",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                fillColor: MyColors.yellow),
                            controller: name,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: GestureDetector(
                          onTap: () async {
                            if (name.text!=null && name.text.trim()!="") {
                              if (code.text!=null && code.text.trim()!="") {
                                gameProvider.startLooking();
                                String gameExsists = await gameProvider.getGame(code.text,name.text);
                                gameProvider.stopLooking();
                                if (gameExsists != "-1") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GameScreen(gameExsists)),
                                  );
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text("wrong code")));
                                }
                              }
                              else{
                                   Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("No code?!")));
                              }
                            }
                            else{
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("No name?!")));
                            }
                          },
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: FlareActor("assets/loadingTri.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: gameProvider.lookingForGame
                                    ? "loading"
                                    : "idle"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameCreator()),
                    );
                  },
                  child: Text(
                    "Create Game",
                    style: TextStyle(
                        color: MyColors.yellow,
                        fontSize: 30,
                        fontFamily: 'Hand'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    code.dispose();
    name.dispose();
    super.dispose();
  }
}
