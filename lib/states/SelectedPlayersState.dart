import 'package:flutter/material.dart';
import 'package:tournament_chess/models/Player.dart';


class SelectedPlayersState extends ChangeNotifier {
  List<Player> list = [];

  SelectedPlayersState();

  void add(Player player) async {
    list.add(player);
    notifyListeners();
  }

  Future<List<Player>> findAll() async {
    return list;
  }

  Future<Player> find(int index) async {
    return list.elementAt(index);
  }

  void delete(Player player) async {
    list.remove(player);
    notifyListeners();
  }
}
