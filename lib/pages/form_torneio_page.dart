import 'package:flutter/material.dart';
import 'package:tournament_chess/controllers/tournament_controller.dart';
import 'package:tournament_chess/pages/rounds_page.dart';
import 'package:tournament_chess/states/PlayersState.dart';
import 'package:tournament_chess/states/SelectedPlayersState.dart';
import 'package:provider/provider.dart';

import '../models/Player.dart';
import '../models/Tournament.dart';

class FormTorneioPage extends StatefulWidget {
  const FormTorneioPage({super.key});

  @override
  State<FormTorneioPage> createState() => _FormTorneioPageState();
}

class _FormTorneioPageState extends State<FormTorneioPage> {
  final TextEditingController nameController = TextEditingController();
  // tipo de torneio se é suiço ou rodado
  String? typeTorneio = '';

  // torneio rodado
  String? modeRoundRobin = 'single';

  bool _showRoundRobinMode = false;
  bool _showSuicoMode = false;

  bool _startTournamentButton = false;

  TournamentController controller = TournamentController();

  void _validateInput() {

    if(nameController.text.isEmpty)
      return;

    if(_showRoundRobinMode == true && Provider.of<SelectedPlayersState>(context, listen: true).list.length >= 3){
      setState(() {
        _startTournamentButton = true;
      });
    }else{
      setState(() {
        _startTournamentButton = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    _validateInput();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Criar Torneio'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              'Modo do Torneio',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'suico',
                  groupValue: typeTorneio,
                  onChanged: (value) {
                    setState(() {
                      typeTorneio = value;
                      _showRoundRobinMode = false;
                      _showSuicoMode = true;
                    });
                  },
                ),
                Text('Suiço'),
                Spacer(),
                Text('minimo 4 jogadores'),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'round',
                  groupValue: typeTorneio,
                  onChanged: (value) {
                    setState(() {
                      typeTorneio = value;
                      _showRoundRobinMode = true;
                      _showSuicoMode = false;
                    });
                  },
                ),
                Text('Rodada'),
                Spacer(),
                Text('minimo 3 jogadores'),
              ],
            ),
            if (_showRoundRobinMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        color: modeRoundRobin == 'single'
                            ? Colors.greenAccent
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topLeft: Radius.circular(25))),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'single',
                          groupValue: modeRoundRobin,
                          onChanged: (value) {
                            setState(() {
                              modeRoundRobin = value;
                            });
                          },
                        ),
                        Text('Única')
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: !(modeRoundRobin == 'single')
                              ? Colors.greenAccent
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'dobro',
                            groupValue: modeRoundRobin,
                            onChanged: (value) {
                              setState(() {
                                modeRoundRobin = value;
                              });
                            },
                          ),
                          Text('Dupla'),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      )),
                ],
              ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Jogadores: ${Provider.of<SelectedPlayersState>(context, listen: true).list.length}',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      listPersons(context);
                    },
                    child: Icon(Icons.group)),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      formPerson(context);
                    },
                    child: Icon(Icons.person_add)),
              ],
            ),
            //  LISTA DE JOGADORES ADICIONADO
            Consumer<SelectedPlayersState>(
              builder: (context, selectedPeople, widget) {
                return Column(
                  children: Provider.of<SelectedPlayersState>(context,
                                  listen: true)
                              .list
                              .length <=
                          0
                      ? []
                      : List.generate(selectedPeople.list.length, (index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black26))),
                            child: Row(
                              children: [
                                Text(
                                  '${selectedPeople.list[index].name} - ${selectedPeople.list[index].elo}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    editPerson(
                                        context, selectedPeople.list[index]);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<SelectedPlayersState>(context,
                                            listen: false)
                                        .delete(selectedPeople.list[index]);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: !_startTournamentButton
            ? null
            : ()  {
          List<Player> players = Provider.of<SelectedPlayersState>(context, listen: false).list;
          Tournament tournament = controller.createTournament(
                    nameController.text,
                  '$typeTorneio',
                  '$typeTorneio' == 'round' ? '$modeRoundRobin' : '',
                     players//List.from(players)
                );

                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RoundsPage(tournament)));
              },
        child: const Text(
          'Começar Torneio',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(300, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

formPerson(context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController eloController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        TextButton(
          onPressed: () {
            Provider.of<PlayersState>(context, listen: false)
                .add(nameController.text, int.parse(eloController.text));
            Provider.of<SelectedPlayersState>(context, listen: false).add(
                Provider.of<PlayersState>(context, listen: false).list.last);
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        )
      ],
      title: const Text('Adicionar Jogador'),
      contentPadding: const EdgeInsets.all(20.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: eloController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Elo',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

editPerson(context, Player player) {
  final TextEditingController nameEditController =
      TextEditingController(text: player.name);
  final TextEditingController eloEditController =
      TextEditingController(text: '${player.elo}');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        TextButton(
          onPressed: () {
            Provider.of<PlayersState>(context, listen: false).update(
                nameEditController.text,
                int.parse(eloEditController.text),
                player.id ?? -1);
            Provider.of<SelectedPlayersState>(context, listen: false)
                .delete(player);
            player.name = nameEditController.text;
            player.elo = int.parse(eloEditController.text);
            Provider.of<SelectedPlayersState>(context, listen: false)
                .add(player);
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        )
      ],
      title: const Text('Editar Jogador'),
      contentPadding: const EdgeInsets.all(20.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: eloEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Elo',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

listPersons(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Adicionar Pessoas'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
      content: ListPeopleDialog(),
    ),
  );
}

class ListPeopleDialog extends StatefulWidget {
  const ListPeopleDialog({super.key});

  @override
  State<ListPeopleDialog> createState() => _ListPeopleDialogState();
}

class _ListPeopleDialogState extends State<ListPeopleDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayersState>(
      builder: (context, personState, widget) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(personState.list.length, (index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26))),
                child: Row(
                  children: [
                    Checkbox(
                        value: Provider.of<SelectedPlayersState>(context,
                                listen: false)
                            .list
                            .contains(personState.list[index]),
                        onChanged: (value) {
                          setState(() {

                            if (value == true) {
                              Provider.of<SelectedPlayersState>(context,
                                      listen: false)
                                  .add(personState.list[index]);
                            } else {
                              Provider.of<SelectedPlayersState>(context,
                                      listen: false)
                                  .delete(personState.list[index]);
                            }
                          });
                        }),
                    Text(
                        '${personState.list[index].name} - ${personState.list[index].elo}'),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        editPerson(context, personState.list[index]);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.orange,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        personState.delete(personState.list[index].id ?? -1);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
