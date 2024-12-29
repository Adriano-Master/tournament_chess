import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_chess/states/PlayersState.dart';
import 'package:tournament_chess/states/SelectedPlayersState.dart';
import 'package:tournament_chess/states/TournamentState.dart';
import 'models/Tournament.dart';
import 'pages/home_page.dart';


void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PlayersState()),
      ChangeNotifierProvider(create: (_) => TournamentState()),
      ChangeNotifierProvider(create: (_) => SelectedPlayersState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capivara Tournament',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      home: const HomePage(title: 'Malaco House Tournament'),
    );
  }
}
