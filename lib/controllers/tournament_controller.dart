import 'package:tournament_chess/models/Player.dart';
import '../models/Tournament.dart';
import '../states/TournamentState.dart';

class TournamentController {

  Tournament createTournament(String name, String type, String mode, List<Player> players) {

    TournamentState tournamentState = TournamentState();

    Tournament tournament = tournamentState.add( players , name, type, mode);
    return tournament;
  }
}