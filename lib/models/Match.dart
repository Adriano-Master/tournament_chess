import 'package:tournament_chess/models/Player.dart';

class Match{
  final int? id;
  final Player player1;
  final Player player2;
  final String result;
  final int round = 0;

  Match(this.player1, this.player2, this.result, {this.id});
}