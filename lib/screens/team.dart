import 'package:commons/commons.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_manager/adapter/team_adapter.dart';
import 'package:team_manager/models/team.dart';
import 'package:team_manager/providers/app_provider.dart';
import 'package:team_manager/screens/main_user.dart';

class Team extends StatefulWidget {
  Team({Key key}) : super(key: key);

  @override
  _Team createState() => _Team();
}

class _Team extends State<Team> {
  final _formKey = GlobalKey<FormState>();
  TeamEntity teamEntity;

  final TextEditingController _name = TextEditingController();

  void saveDebt(BuildContext context) async {
    waitDialog(context, message: 'Saving...');

    teamEntity = TeamEntity(name: _name.text);
    await TeamAdapter().saveTeam(teamEntity).then((value) {
      Provider.of<AppProvider>(context, listen: false).getTeams();
      Navigator.pop(context);
      successDialog(context, 'Successfully created', neutralAction: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainApp(
                      selectedIndex: 1,
                    )));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Team"),
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
                        saveDebt(context);
                      }
                    },
                    child: Text('Create Team'),
                  ),
                )
              ],
            )));
  }
}
