import 'package:sqflite/sqflite.dart';
import 'package:tournament_chess/databases/conection.dart';

class TournamentDao {
  static const String _tablename = 'torneios';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _date = 'date';
  static const String _status = 'status';
  static const String _type = 'type';
  static const String _rounds = 'rounds';
  static const String tournamentTableSql = "CREATE TABLE $_tablename("
      "$_id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$_name TEXT, "
      "$_date TEXT, "
      "$_status INTEGER, "
      "$_type TEXT, "
      "$_rounds INTEGER); ";

  Future<Object> save(Tournament tournament) async {
    print('inicinado o save');
    final Database db = await getDatabase();
    var itemExists = await find(tournament.name);

    if(itemExists.isEmpty){
      print('tournament not exists');
      return await db.insert(_tablename, toMap(tournament));
    }else{
      print('tournament exists');
      return db.update(_tablename, toMap(tournament), where: '$_name = ?', whereArgs: [tournament.name]);
    }

  }

  Future<List<Tournament>> findAll() async {
    final Database db = await getDatabase();
    print('acessando findAll de tournament..');
    final List<Map<String, dynamic>> res = await db.query(_tablename);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Tournament>> find(String name) async {
    final Database db = await getDatabase();
    print('acessando find de tournament..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_name = ?', whereArgs: [name]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Tournament>> findById(int id) async {
    final Database db = await getDatabase();
    print('acessando find de round..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_id = ?', whereArgs: [id]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

Future<int> delete(String name) async{
  print('deletando tournament');
  final Database db = await getDatabase();
  return await db.delete(_tablename, where: '$_name = ?', whereArgs: [name]);
}

  List<Tournament> toList(List<Map<String, dynamic>> list) {
    final List<Tournament> tournaments = [];
    for (Map<String, dynamic> row in list) {
      final Tournament t = Tournament.name(
          row[_name], row[_date], row[_status], row[_type], row[_rounds], id: row[_id]);
      tournaments.add(t);
    }
    return tournaments;
  }

  Map<String, dynamic> toMap(Tournament tournament){
    final Map<String, dynamic> mapTournament = {};
    mapTournament[_name] = tournament.name;
    mapTournament[_date] = tournament.date;
    mapTournament[_status] = tournament.status;
    mapTournament[_type] = tournament.type;
    mapTournament[_rounds] = tournament.rounds;
    mapTournament[_id] = tournament.id;
    return mapTournament;
  }
}
