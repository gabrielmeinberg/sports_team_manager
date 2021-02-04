import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_manager/adapter/player_adapter.dart';
import 'package:team_manager/models/player.dart';
import 'package:team_manager/providers/app_provider.dart';
import 'package:team_manager/screens/main_user.dart';

class PlayerShow extends StatefulWidget {
  PlayerShow({Key key, this.playerEntity}) : super(key: key);

  final PlayerEntity playerEntity;

  @override
  _PlayerShow createState() => _PlayerShow();
}

class _PlayerShow extends State<PlayerShow> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    _name.text = widget.playerEntity.name;
    super.initState();
  }

  void updateTeam(BuildContext context) async {
    waitDialog(context, message: 'Saving...');
    await PlayerAdapter()
        .updatePlayer(widget.playerEntity, _name.text)
        .then((value) {
      Provider.of<AppProvider>(context, listen: false).getPlayers();
      Navigator.pop(context);
      successDialog(context, 'Successfully updated');
    });
  }

  Future<void> deletePlayerTeam(BuildContext context) async {
    await confirmationDialog(context, "Do you Confirm to delete the Player?",
        positiveText: "Remove", positiveAction: () {
      PlayerAdapter().deletePlayer(widget.playerEntity).then((value) {
        Provider.of<AppProvider>(context, listen: false).getTeams();
        Provider.of<AppProvider>(context, listen: false).getPlayers();
      });
    });

    await successDialog(context, 'Successfully Player Deleted');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Player"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => deletePlayerTeam(context),
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
                          Icons.face,
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
                  child: Text('Update Player'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Teams",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      )
                    ],
                  )),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.playerEntity.teams.length != 0
                      ? widget.playerEntity.teams.length
                      : 0,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ListTile(
                      leading: Icon(Icons.group),
                      title: Text(widget.playerEntity.teams[index].name),
                    );
                  }))
        ]));
  }
}
