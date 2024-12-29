import 'package:flutter/material.dart';
import 'package:tournament_chess/models/Player.dart';


class PlayersState extends ChangeNotifier {
  List<Player> list = [
    Player('Adriano', 1400, id: 1),
    Player('Malaco', 1400, id: 2),
    Player('Marcos', 1400, id: 3),
  ];

  static int _countId = 4;

  static int get countId => _countId;

  PlayersState();

  void add(String name, int elo) async {
    list.add(Player(name, elo, id: countId));
    _countId++;
    notifyListeners();
  }

  void update(String name, int elo, int id) async {
    for(Player person in list){
      if(person.id == id){
        person.name = name;
        person.elo = elo;
      }
    }
    notifyListeners();
  }

  Future<List<Player>> findAll() async {
    return list;
  }

  Future<Player> find(int index) async {
    return list.elementAt(index);
  }

  void delete(int index) async {
    list.removeWhere((Player elem) => elem.id == index);
    notifyListeners();
  }
}
