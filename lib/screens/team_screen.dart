import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_manager/models/team.dart';
import 'package:team_manager/providers/app_provider.dart';
import 'package:team_manager/screens/team_show.dart';

//receivable
class TeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<TeamEntity> listTeamEntity =
        Provider.of<AppProvider>(context).listTeamEntity;
    return Scaffold(
      body: listTeamEntity.length == 0
          ? Center(
              child: Text("There are no Teams"),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: false,
                        itemCount:
                            listTeamEntity != null ? listTeamEntity.length : 0,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ListTile(
                            leading: Icon(Icons.group),
                            title: Text(listTeamEntity[index].name),
                            subtitle: Text(
                                'Players: ${listTeamEntity[index].players.length}'),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamShow(
                                        teamEntity: listTeamEntity[index]))),
                          );
                        }))
              ],
            ),
    );
  }
}
