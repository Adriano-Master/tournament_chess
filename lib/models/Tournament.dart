import 'package:intl/intl.dart';
import 'package:tournament_chess/models/Player.dart';
import 'package:tournament_chess/models/Match.dart';

class Tournament {

  int? id;
  String name;
  String date = '';
  int status = 0;
  String type;
  String mode;

  List<Player> players;
  List<List<Match>> rounds = [];

  Tournament(this.players, this.name, this.type, this.mode, {this.id}){
    DateTime agora = DateTime.now();
    var formatador = DateFormat('dd/MM/yyyy');
    this.date = formatador.format(agora);
    this.organizeRounds();
    this.printRounds();
  }

  void organizeRounds() {
    if(type == 'round'){
      int numRounds = mode == 'single' ? players.length - 1 : (players.length - 1) * 2;
      for (int round = 0; round < numRounds; round++) {
        List<Match> matches = [];
        for (int i = 0; i < players.length / 2; i++) {
          int player1Index = (round + i) % (players.length - 1);
          int player2Index = (players.length - 1 - i + round) % (players.length - 1);
          if (i == 0) player2Index = players.length - 1;
          if (mode == 'double' && round % 2 == 1) {
            matches.add(Match(players[player2Index], players[player1Index], '0.0-0.0')); // Placeholder result
          } else {
            matches.add(Match(players[player1Index], players[player2Index], '0.0-0.0')); // Placeholder result
          }
        }
        rounds.add(matches);
      }
    }
  }

  void printStandings() {
    players.sort((a, b) => b.points.compareTo(a.points));
    for (var player in players) {
      print('${player.name}: ${player.points}');
    }
  }

  void printRounds() {
    for (int i = 0; i < rounds.length; i++) {
      print('Round ${i + 1}:');
      for (var match in rounds[i]) {
        print('${match.player1.name} vs ${match.player2.name} (${match.result})');
      }
      print('');
    }
  }
}
