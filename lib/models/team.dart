import 'package:team_manager/adapter/player_team_adapter.dart';
import 'package:team_manager/models/player.dart';

class TeamEntity {
  int id;
  String name;
  List<PlayerEntity> players;

  TeamEntity({this.id, this.name, this.players});

  setName(String name) {
    this.name = name;
  }

  Future<void> getPlayers() async {
    this.players = await PlayerTeamAdapter().getPlayersByTeam(this);
  }

  TeamEntity.fromMap(Map snapshot)
      : id = snapshot['id'],
        name = snapshot['name'];
}
