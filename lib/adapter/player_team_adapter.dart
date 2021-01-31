import 'package:team_manager/adapter/player_adapter.dart';
import 'package:team_manager/adapter/team_adapter.dart';
import 'package:team_manager/models/player.dart';
import 'package:team_manager/models/team.dart';
import 'package:team_manager/repository/mysqlite.dart';

class PlayerTeamAdapter {
  var db = TeamManagerDB();

  Future<void> insertPlayerInTeam(TeamEntity team, PlayerEntity player) async {
    await db.insertPlayerTeam(player.id, team.id);
  }

  Future<void> deletePlayerTeam(TeamEntity team, PlayerEntity player) async {
    await db.deletePlayerTeam(player.id, team.id);
  }

  Future<List<PlayerEntity>> getPlayersByTeam(TeamEntity team) async {
    List<Map> playersTeam = await db.getPlayerTeam(team.id);
    List<Future<PlayerEntity>> playerEntitiesFutures = [];

    playersTeam.forEach((element) => playerEntitiesFutures
        .add(PlayerAdapter().getPlayerById(element['player_id'])));

    return await Future.wait(playerEntitiesFutures);
  }

  Future<List<TeamEntity>> getTeamsByPlayer(PlayerEntity player) async {
    List<Map> teamsPlayer = await db.getTeamsPlayer(player.id);
    List<Future<TeamEntity>> teamEntitiesFutures = [];

    teamsPlayer.forEach((element) =>
        teamEntitiesFutures.add(TeamAdapter().getTeamById(element['team_id'])));

    return await Future.wait(teamEntitiesFutures);
  }
}
