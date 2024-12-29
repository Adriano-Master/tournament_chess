import 'package:sqflite/sqflite.dart';
import 'package:tournament_chess/databases/conection.dart';

class RoundDao {

  static const String _tablename = 'rounds';
  static const String _id = 'id';
  static const String _number = 'number';
  static const String _tournament = 'tournament';
  static const String roundTableSql = "CREATE TABLE $_tablename("
      "$_id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$_number INTEGER, "
      "$_tournament TEXT);";

  Future<Object> save(Round round) async {
    print('inicinado o save round');
    final Database db = await getDatabase();
    var itemExists = await find(round.number, round.tournament);

    if(itemExists.isEmpty){
      print('tournament not exists');
      return await db.insert(_tablename, toMap(round));
    }else{
      print('tournament exists');
      return db.update(_tablename, toMap(round), where: '$_number = ? AND $_tournament = ?', whereArgs: [round.number, round.tournament]);
    }

  }

  Future<List<Round>> findAll() async {
    final Database db = await getDatabase();
    print('acessando findAll de person..');
    final List<Map<String, dynamic>> res = await db.query(_tablename);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Round>> find(int index, String tournament) async {
    final Database db = await getDatabase();
    print('acessando find de round..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_number = ? AND $_tournament = ?', whereArgs: [index, tournament]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Round>> findById(int id) async {
    final Database db = await getDatabase();
    print('acessando find de round..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_id = ?', whereArgs: [id]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<int> delete(int id) async{
    print('deletando person');
    final Database db = await getDatabase();
    return await db.delete(_tablename, where: '$_id = ? ', whereArgs: [id]);
  }

  List<Round> toList(List<Map<String, dynamic>> list) {
    final List<Round> rounds = [];
    for (Map<String, dynamic> row in list) {
      final Round t = Round.name(
        row[_number], row[_tournament], id: row[_id]);
      rounds.add(t);
    }
    return rounds;
  }

  Map<String, dynamic> toMap(Round round){
    final Map<String, dynamic> roundMap = {};
    roundMap[_id] = round.id;
    roundMap[_number] = round.number;
    roundMap[_tournament] = round.tournament;
    return roundMap;
  }
}