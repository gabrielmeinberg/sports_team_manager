import 'package:team_manager/models/team.dart';
import 'package:team_manager/repository/mysqlite.dart';

class TeamAdapter {
  var db = TeamManagerDB();

  Future<TeamEntity> saveTeam(TeamEntity team) async {
    team.id = await db.insertTeam(team.name);
    return team;
  }

  Future<TeamEntity> updateTeam(TeamEntity team, String name) async {
    await db.updateTeam(team.id, name);
    team.setName(name);
    return team;
  }

  Future<void> deleteTeam(TeamEntity team) async {
    await db.deleteTeamFromPlayerTeams(team.id);
    await db.deleteTeam(team.id);
    return null;
  }

  Future<List<TeamEntity>> getTeams() async {
    List<Map> teams = await db.getTeam();
    List<Future> getPlayersFuture = [];

    List<TeamEntity> teamEntities = teams.map((team) {
      TeamEntity teamEntity = TeamEntity.fromMap(team);
      getPlayersFuture.add(teamEntity.getPlayers());
      return teamEntity;
    }).toList();
    await Future.wait(getPlayersFuture);
    return teamEntities;
  }

  Future<TeamEntity> getTeamById(int id) async {
    Map team = await db.getTeamById(id);
    return TeamEntity.fromMap(team);
  }
}
