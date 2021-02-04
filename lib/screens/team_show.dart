import 'package:commons/commons.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_manager/adapter/player_team_adapter.dart';
import 'package:team_manager/adapter/team_adapter.dart';
import 'package:team_manager/models/player.dart';
import 'package:team_manager/models/team.dart';
import 'package:team_manager/providers/app_provider.dart';
import 'package:team_manager/screens/main_user.dart';

class TeamShow extends StatefulWidget {
  TeamShow({Key key, this.teamEntity}) : super(key: key);

  final TeamEntity teamEntity;

  @override
  _TeamShow createState() => _TeamShow();
}

class _TeamShow extends State<TeamShow> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  Set<SimpleItem> listPlayer = Set<SimpleItem>();
  List<PlayerEntity> listPlayersEntity;

  @override
  void initState() {
    _name.text = widget.teamEntity.name;
    super.initState();
  }

  void updateTeam(BuildContext context) async {
    waitDialog(context, message: 'Saving...');
    await TeamAdapter().updateTeam(widget.teamEntity, _name.text).then((value) {
      Provider.of<AppProvider>(context, listen: false).getTeams();
      Provider.of<AppProvider>(context, listen: false).getPlayers();
      Navigator.pop(context);
      successDialog(context, 'Successfully updated');
    });
  }

  Future<void> getPlayersTeam(BuildContext context) async {
    setState(() {
      listPlayer = Set<SimpleItem>();
    });
    listPlayersEntity.forEach((e) {
      widget.teamEntity.players.firstWhere((bosta) => bosta.id == e.id,
          orElse: () {
        listPlayer.add(SimpleItem(e.id, e.name));
        return null;
      });
    });

    singleSelectDialog(context, "Select Player", listPlayer, (item) {
      PlayerEntity playerSelected =
          listPlayersEntity.where((e) => e.id == item.id).first;
      PlayerTeamAdapter()
          .insertPlayerInTeam(widget.teamEntity, playerSelected)
          .then((_) {
        setState(() {
          Future.wait([PlayerTeamAdapter().getPlayersByTeam(widget.teamEntity)])
              .then((value) {
            setState(() {
              widget.teamEntity.players = value.first;
            });
          });
        });
        Provider.of<AppProvider>(context, listen: false).getTeams();
        Provider.of<AppProvider>(context, listen: false).getPlayers();
        successDialog(context, 'Player successfully added');
      });
    });
  }

  Future<void> deletePlayerTeam(BuildContext context, int playerId) async {
    confirmationDialog(context, "Do you Confirm to remove the Player?",
        positiveText: "Remove", positiveAction: () {
      PlayerEntity playerSelected =
          listPlayersEntity.where((e) => e.id == playerId).first;
      PlayerTeamAdapter()
          .deletePlayerTeam(widget.teamEntity, playerSelected)
          .then((value) {
        Provider.of<AppProvider>(context, listen: false).getTeams();
        Provider.of<AppProvider>(context, listen: false).getPlayers();

        setState(() {
          Future.wait([PlayerTeamAdapter().getPlayersByTeam(widget.teamEntity)])
              .then((value) {
            setState(() {
              widget.teamEntity.players = value.first;
            });
          });
        });

        successDialog(context, 'Successfully removed');
      });
    });
  }

  Future<void> deleteTeam(BuildContext context) async {
    await confirmationDialog(context, "Do you Confirm to delete the Team?",
        positiveText: "Remove", positiveAction: () {
      TeamAdapter().deleteTeam(widget.teamEntity).then((value) {
        Provider.of<AppProvider>(context, listen: false).getTeams();
        Provider.of<AppProvider>(context, listen: false).getPlayers();
      });
    });

    await successDialog(context, 'Successfully Team Deleted');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainApp()));
  }

  @override
  Widget build(BuildContext context) {
    listPlayersEntity =
        Provider.of<AppProvider>(context, listen: false).listPlayerEntity;
    return Scaffold(
        appBar: AppBar(
          title: Text("Team"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => deleteTeam(context),
                  child: Icon(Icons.delete_forever),
                )),
          ],
        ),
        body: Column(children: [
          ListView(
            padding: EdgeInsets.all(20.0),
            shrinkWrap: true,
            children: [
              Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.group,
                          color: Colors.black,
                        ),
                        labelText: 'Name',
                        hintText: 'Name',
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a Name';
                        }
                      },
                      controller: _name,
                    )
                  ])),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      updateTeam(context);
                    }
                  },
                  child: Text('Update Team'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Players",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () => getPlayersTeam(context),
                            child: Icon(Icons.person_add),
                          ))
                    ],
                  )),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.teamEntity.players.length != 0
                      ? widget.teamEntity.players.length
                      : 0,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ListTile(
                      leading: Icon(Icons.face),
                      title: Text(widget.teamEntity.players[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deletePlayerTeam(
                            context, widget.teamEntity.players[index].id),
                      ),
                    );
                  }))
        ]));
  }
}
