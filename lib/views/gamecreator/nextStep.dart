import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:xplain/myColors.dart';

class NextStep extends StatelessWidget {
  final String toWhere;
  final Function function;
  const NextStep({Key key, this.toWhere, this.function}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.bottomGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 15,
            blurRadius: 20,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              toWhere,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),
            SizedBox(width: 8),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    function();
                  },
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: FlareActor("assets/loadingTri.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "idle"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
