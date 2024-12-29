import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_chess/models/Tournament.dart';
import 'package:tournament_chess/pages/form_torneio_page.dart';
import 'package:tournament_chess/pages/rounds_page.dart';
import 'package:tournament_chess/states/TournamentState.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: (){
            print('---------------------------------------');
            print(Provider.of<TournamentState>(context, listen: false).list);
            print('---------------------------------------');

          }, icon: Icon(Icons.print))
        ],
      ),
      body: Consumer<TournamentState>(
        builder: (context, tournamentState, widget) {
          return ListView.builder(
            itemCount: tournamentState.list.length,
            itemBuilder: (BuildContext context, int index) {
              Tournament tournament = tournamentState.find(index);
              return tournamentComponent(
                  Tournament(
                    tournament.players,
                    tournament.name,
                    tournament.type,
                    tournament.mode,
                id: tournament.id ?? -1,)
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FormTorneioPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class tournamentComponent extends StatelessWidget {

 final Tournament tournament;

  const tournamentComponent(this.tournament);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoundsPage(tournament)));
      },
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border(left: BorderSide(width: 10, color: Colors.green)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 3,
                blurRadius: 13,
                offset: Offset(0, 3),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tournament.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(tournament.date),
            Text(tournament.type),
            Text('Total de rodadas: 0'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tournament.status == 0
                    ? Text(
                        'Em andamento',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.lightGreen),
                      )
                    : Text(
                        'Finalizado',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey),
                      ),
                PopupMenuButton(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'classification',
                      child: Row(
                        children: [
                          const Icon(Icons.format_list_numbered_outlined),
                          SizedBox(width: 10),
                          const Text('Classificação')
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      onTap: (){
                        Provider.of<TournamentState>(context, listen: false).delete(int.parse('${tournament.id}'));
                      },
                      value: 'delete',
                      child: const Row(
                        children: [
                          const Icon(Icons.delete),
                          SizedBox(width: 10),
                          const Text('Excluir')
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
