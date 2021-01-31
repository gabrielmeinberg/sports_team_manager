import 'package:team_manager/adapter/player_team_adapter.dart';
import 'package:team_manager/models/team.dart';

class PlayerEntity {
  int id;
  String name;
  List<TeamEntity> teams;

  PlayerEntity({this.id, this.name, this.teams});

  setName(String name) {
    this.name = name;
  }

  Future<void> getTeams() async {
    this.teams = await PlayerTeamAdapter().getTeamsByPlayer(this);
  }

  PlayerEntity.fromMap(Map snapshot)
      : id = snapshot['id'],
        name = snapshot['name'];
}
