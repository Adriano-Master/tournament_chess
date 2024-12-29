import 'package:flutter/material.dart';

import '../models/Player.dart';
import '../models/Tournament.dart';

class TournamentState extends ChangeNotifier {

  // A instância única da classe
  static final TournamentState _instance = TournamentState._internal([]);

  // Construtor privado
  TournamentState._internal(this.list);

  // Método factory que retorna a instância única
  factory TournamentState() { return _instance; }

  List<Tournament> list;
  static int _countId = 4;

  static int get countId => _countId;

  Tournament add(List<Player> players, String name, String type, String mode) {
  Tournament t = Tournament(players, name, type, mode, id: countId);
    list.add(t);
    _countId++;
    notifyListeners();
    return t;
  }

  Future<List<Tournament>> findAll() async {
    return list;
  }

  Tournament find(int index) {
    return list.elementAt(index);
  }

  void delete(int index) async {
    list.removeWhere((Tournament elem) => elem.id == index);
    notifyListeners();
  }
}
