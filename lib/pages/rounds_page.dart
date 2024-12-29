import 'package:flutter/material.dart';
import 'package:tournament_chess/models/Tournament.dart';
import 'package:provider/provider.dart';
import 'package:tournament_chess/states/TournamentState.dart';
import 'package:tournament_chess/models/Match.dart';

class RoundsPage extends StatelessWidget {
  final Tournament tournament;

  RoundsPage(this.tournament);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('${tournament.name}'),
      ),
      body: Consumer<TournamentState>(builder: (context, tournaments, widget) {
        return RoundComponent(tournament);
      }),
    );
  }
}

class RoundComponent extends StatelessWidget {
  Tournament tournament;

  RoundComponent(this.tournament);

  List<Widget> _showMatchsComponent(List<Match> matchs) {
    return List.generate(matchs.length, (index) {
      return Container(
        width: 200,
        margin: EdgeInsets.all(5),
        //padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text('${matchs[index].player1.name}'),
                  Text('${matchs[index].player1.elo}'),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  Text('vs'),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  Text('${matchs[index].player2.name}'),
                  Text('${matchs[index].player2.elo}'),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        children: List.generate(tournament.rounds.length, (index) {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            //  BARRA SUPERIOR COM TITULO
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        'Rodada ${index + 1}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              children:
                  _showMatchsComponent(List.from(tournament.rounds[index])),
            ),
          ],
        ),
      );
    }));
  }
}
