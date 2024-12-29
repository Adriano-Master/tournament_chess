import 'package:sqflite/sqflite.dart';
import 'package:tournament_chess/databases/conection.dart';

class PersonTournament {
  final String tournament;
  final String person;

  PersonTournament.name(this.tournament, this.person);
}

class PersonTournamentDao {
  static const String _tablename = 'person_tournament';
  static const String _tournament = 'tournament';
  static const String _person = 'person';
  static const String personTournamentTableSql = "CREATE TABLE $_tablename("
      "$_tournament TEXT, "
      "$_person TEXT);";

  Future<Object> save(PersonTournament pt) async {
    print('inicinado o save person_tournament');
    final Database db = await getDatabase();
    var itemExists = await find(pt.person, pt.tournament);

    if (itemExists.isEmpty) {
      print('person_tournament not exists');
      return await db.insert(_tablename, toMap(pt));
    } else {
      print('person_tournament exists');
      return db.update(_tablename, toMap(pt),
          where: '$_person = ? AND $_tournament',
          whereArgs: [pt.person, pt.tournament]);
    }
  }

  Future<List<PersonTournament>> find(String name, String tournament) async {
    final Database db = await getDatabase();
    print('acessando find de person..');
    final List<Map<String, dynamic>> res = await db.query(_tablename,
        where: '$_person = ? AND $_tournament = ?',
        whereArgs: [name, tournament]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<int> delete(String person, String tournament) async {
    print('deletando person');
    final Database db = await getDatabase();
    return await db.delete(_tablename,
        where: '$_person = ? AND $_tournament',
        whereArgs: [person, tournament]);
  }

  List<PersonTournament> toList(List<Map<String, dynamic>> list) {
    final List<PersonTournament> pts = [];
    for (Map<String, dynamic> row in list) {
      final PersonTournament t =
          PersonTournament.name(row[_person], row[_tournament]);
      pts.add(t);
    }
    return pts;
  }

  Map<String, dynamic> toMap(PersonTournament pt) {
    final Map<String, dynamic> ptMap = {};
    ptMap[_person] = pt.person;
    ptMap[_tournament] = pt.tournament;
    return ptMap;
  }
}
