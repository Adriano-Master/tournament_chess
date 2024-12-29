import 'package:sqflite/sqflite.dart';
import 'package:tournament_chess/databases/conection.dart';

class PersonDao {

  static const String _tablename = 'persons';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _elo = 'elo';
  static const String peopleTableSql = "CREATE TABLE $_tablename("
      "$_id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$_name TEXT, "
      "$_elo INTEGER);";

  Future<Object> save(Person person) async {
    print('inicinado o save person');
    final Database db = await getDatabase();
    var itemExists = await find(person.name);

    if(itemExists.isEmpty){
      print('tournament not exists');
      return await db.insert(_tablename, toMap(person));
    }else{
      print('tournament exists');
      return db.update(_tablename, toMap(person), where: '$_name = ?', whereArgs: [person.name]);
    }

  }

  Future<List<Person>> findAll() async {
    final Database db = await getDatabase();
    print('acessando findAll de person..');
    final List<Map<String, dynamic>> res = await db.query(_tablename);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Person>> find(String name) async {
    final Database db = await getDatabase();
    print('acessando find de person..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_name = ?', whereArgs: [name]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<List<Person>> findById(int id) async {
    final Database db = await getDatabase();
    print('acessando find de round..');
    final List<Map<String, dynamic>> res = await db.query(_tablename, where: '$_id = ?', whereArgs: [id]);
    print('procurando dados...');
    db.close();
    return toList(res);
  }

  Future<int> delete(String name) async{
    print('deletando person');
    final Database db = await getDatabase();
    return await db.delete(_tablename, where: '$_name = ?', whereArgs: [name]);
  }

  List<Person> toList(List<Map<String, dynamic>> list) {
    final List<Person> persons = [];
    for (Map<String, dynamic> row in list) {
      final Person t = Person(
          row[_name], row[_elo], id: row[_id]);
      persons.add(t);
    }
    return persons;
  }

  Map<String, dynamic> toMap(Person person){
    final Map<String, dynamic> mapTournament = {};
    mapTournament[_name] = person.name;
    mapTournament[_elo] = person.elo;
    mapTournament[_id] = person.id;
    return mapTournament;
  }
}