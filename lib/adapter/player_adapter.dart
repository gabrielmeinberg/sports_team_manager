import 'package:team_manager/models/player.dart';
import 'package:team_manager/repository/mysqlite.dart';

class PlayerAdapter {
  var db = TeamManagerDB();

  Future<PlayerEntity> savePlayer(PlayerEntity player) async {
    player.id = await db.insertPlayer(player.name);
    return player;
  }

  Future<PlayerEntity> updatePlayer(PlayerEntity player, String name) async {
    await db.updatePlayer(player.id, name);
    player.name = name;
    return player;
  }

  Future<void> deletePlayer(PlayerEntity player) async {
    await db.deletePlayer(player.id);
    return null;
  }

  Future<List<PlayerEntity>> getPlayers() async {
    List<Map> players = await db.getPlayer();
    List<Future> getTeamsFuture = [];

    List<PlayerEntity> playerEntities = players.map((player) {
      PlayerEntity playerEntity = PlayerEntity.fromMap(player);
      getTeamsFuture.add(playerEntity.getTeams());
      return playerEntity;
    }).toList();
    await Future.wait(getTeamsFuture);
    return playerEntities;
  }

  Future<PlayerEntity> getPlayerById(int id) async {
    Map player = await db.getPlayerById(id);
    return PlayerEntity.fromMap(player);
  }
}
