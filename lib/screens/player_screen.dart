import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_manager/models/player.dart';
import 'package:team_manager/providers/app_provider.dart';
import 'package:team_manager/screens/player_show.dart';

//receivable
class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PlayerEntity> listPlayerEntity =
        Provider.of<AppProvider>(context).listPlayerEntity;
    return Scaffold(
      body: listPlayerEntity.length == 0
          ? Center(
              child: Text("There are no Players"),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: listPlayerEntity != null
                            ? listPlayerEntity.length
                            : 0,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ListTile(
                              leading: Icon(Icons.face),
                              title: Text(listPlayerEntity[index].name),
                              subtitle: Text(
                                  'Team: ${listPlayerEntity[index].teams.length}'),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerShow(
                                          playerEntity:
                                              listPlayerEntity[index]))));
                        }))
              ],
            ),
    );
  }
}
