import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tournament_chess/databases/person_dao.dart';
import 'package:tournament_chess/databases/person_tournament_dao.dart';
import 'package:tournament_chess/databases/tournament_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'tounament.db');

  return openDatabase(path,
      version: 1,
      onCreate: (Database db, int version) => {
            db.execute(
                '${TournamentDao.tournamentTableSql} ${PersonDao.peopleTableSql} ${PersonTournamentDao.personTournamentTableSql}')
          });
}
