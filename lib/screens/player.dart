import 'package:commons/commons.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_manager/adapter/player_adapter.dart';
import 'package:team_manager/models/player.dart';
import 'package:team_manager/providers/app_provider.dart';
import 'package:team_manager/screens/main_user.dart';

class Player extends StatefulWidget {
  Player({Key key}) : super(key: key);

  @override
  _Player createState() => _Player();
}

class _Player extends State<Player> {
  final _formKey = GlobalKey<FormState>();
  PlayerEntity playerEntity;

  final TextEditingController _name = TextEditingController();

  void saveDebt(BuildContext context) async {
    waitDialog(context, message: 'Saving...');
    playerEntity = PlayerEntity(name: _name.text);
    await PlayerAdapter().savePlayer(playerEntity).then((value) {
      Provider.of<AppProvider>(context, listen: false).getPlayers();
      Navigator.pop(context);
    });
    await successDialog(context, 'Successfully created', neutralAction: () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainApp()));
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Player"),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
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
                        saveDebt(context);
                      }
                    },
                    child: Text('Create Player'),
                  ),
                )
              ],
            )));
  }
}
