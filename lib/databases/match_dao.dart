import 'package:sqflite/sqflite.dart';
import 'package:tournament_chess/databases/conection.dart';

class MatchDao {

  static const String _tablename = 'matchs';
  static const String _id = 'id';
  static const String _person_1 = 'person_1';
  static const String _person_2 = 'person_2';
  static const String _result = 'result';
  static const String _round = 'round';
  static const String roundTableSql = "CREATE TABLE $_tablename("
      "$_id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$_person_1 TEXT, "
      "$_person_2 TEXT"
      "$_result TEXT"
      "$_round TEXT);";

  Future<Object> save(Match match) async {
    print('inicinado o save match');
    final Database db = await getDatabase();
    var itemExists = await find(match.id ?? 0);

    if(itemExists.isEmpty){
      print('tournament not exists');
      return await db.insert(_tablename, toMap(match));
    }else{
      print('tournament exists');
      return db.update(_tablename, toMap(match), where: '$_id = ? ', whereArgs: [match.id]);
    }

  }

  Future<List<Match>> findAll() async {
    final Database db = await getDatabase();
    print('acessando findAll de match..');
    final List<Map<String, dynamic>> res = await db.query(_tablename);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Match>> find(int id) async {
    final Database db = await getDatabase();
    print('acessando find de match..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_id = ?', whereArgs: [id]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<int> delete(int id) async{
    print('deletando match');
    final Database db = await getDatabase();
    return await db.delete(_tablename, where: '$_id = ? ', whereArgs: [id]);
  }

  List<Match> toList(List<Map<String, dynamic>> list) {
    final List<Match> rounds = [];
    for (Map<String, dynamic> row in list) {
      final Match t = Match(
          row[_person_1], row[_person_2], row[_result], row[_round], id: row[_id]);
      rounds.add(t);
    }
    return rounds;
  }

  Map<String, dynamic> toMap(Match match){
    final Map<String, dynamic> roundMap = {};
    roundMap[_id] = match.id;
    roundMap[_person_1] = match.person_1;
    roundMap[_person_2] = match.person_2;
    roundMap[_result] = match.result;
    roundMap[_round] = match.round;
    roundMap[_id] = match.id;
    return roundMap;
  }
}