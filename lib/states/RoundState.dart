import 'package:flutter/material.dart';
import 'package:tournament_chess/models/Round.dart';

class RoundsState extends ChangeNotifier {

  List<Round> list = [];

  RoundsState();

  void add(Round round) async {
    list.add(round);
    notifyListeners();
  }

  Future<List<Round>> findAll() async {
    return list;
  }

  Future<Round> find(int index) async {
    return list.elementAt(index);
  }

  void delete(Round round) async {
    list.remove(round);
    notifyListeners();
  }
}