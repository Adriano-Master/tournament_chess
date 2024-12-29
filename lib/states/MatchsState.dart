import 'package:flutter/material.dart';

class MatchsState extends ChangeNotifier {

  List<Match> list = [];

  MatchsState();

  void add(Match match) async {
    list.add(match);
    notifyListeners();
  }

  Future<List<Match>> findAll() async {
    return list;
  }

  Future<Match> find(int index) async {
    return list.elementAt(index);
  }

  void delete(Match match) async {
    list.remove(match);
    notifyListeners();
  }
}