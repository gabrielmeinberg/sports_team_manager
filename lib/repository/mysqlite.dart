import 'dart:async';
import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:team_manager/repository/migrations.dart';

class TeamManagerDB {
  createDB() async {
    final int currentVersion = migrations.length;

    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'debt.db');

      // open the database
      return await openDatabase(path, version: currentVersion,
          onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute("CREATE TABLE IF NOT EXISTS migrations ( "
            "id INTEGER PRIMARY KEY,"
            "hash TEXT,"
            "create_at DATETIME DEFAULT CURRENT_TIMESTAMP)"); // When creating the db, create the table

        migrations.forEach((migrate) async {
          var result = await db.rawQuery(
              "SELECT * FROM migrations where hash = ${migrate.hash}");
          if (result != null) {
            await db.rawQuery(migrate.query);
            await db.insert("migrations", {"hash": migrate.hash});
          }
        });
      });
    } catch (e) {
      print("ERRR >>>>");
      print(e);
    }
  }

  Future<int> insertPlayer(String name) async {
    Database _db = await createDB();
    return await _db.insert("player", {"name": name});
  }

  Future<int> updatePlayer(int id, String name) async {
    Database _db = await createDB();
    return await _db.rawUpdate(
        "UPDATE player SET "
        "name = ? "
        "WHERE id = ?",
        [
          name,
          id,
        ]);
  }

  Future<int> deletePlayer(int id) async {
    Database _db = await createDB();
    return await _db.rawDelete('DELETE FROM player WHERE id= ?', [id]);
  }

  Future<List<Map>> getPlayer() async {
    Database _db = await createDB();
    var result = await _db.rawQuery('SELECT * FROM player ORDER BY name');
    if (result != null) {
      return result.toList();
    }
    return null;
  }

  Future<Map> getPlayerById(int id) async {
    Database _db = await createDB();
    var result = await _db.rawQuery('SELECT * FROM player WHERE id=?', [id]);
    if (result != null) {
      return result.toList().first;
    }
    return null;
  }

  Future<int> insertTeam(String name) async {
    Database _db = await createDB();
    return await _db.insert("team", {"name": name});
  }

  Future<int> updateTeam(int id, String name) async {
    Database _db = await createDB();
    return await _db.rawUpdate(
        "UPDATE team SET "
        "name = ? "
        "WHERE id = ?",
        [
          name,
          id,
        ]);
  }

  Future<int> deleteTeam(int id) async {
    Database _db = await createDB();
    return await _db.rawDelete('DELETE FROM team WHERE id= ?', [id]);
  }

  Future<List<Map>> getTeam() async {
    Database _db = await createDB();
    var result = await _db.rawQuery('SELECT * FROM team ORDER BY name');
    if (result != null) {
      return result.toList();
    }
    return null;
  }

  Future<Map> getTeamById(int id) async {
    Database _db = await createDB();
    var result = await _db.rawQuery('SELECT * FROM team WHERE id=?', [id]);
    if (result != null) {
      return result.toList().first;
    }
    return null;
  }

  Future<int> insertPlayerTeam(int playerId, int teamId) async {
    Database _db = await createDB();
    return await _db
        .insert("playerteam", {"player_id": playerId, "team_id": teamId});
  }

  Future<int> deletePlayerTeam(int playerId, int teamId) async {
    Database _db = await createDB();
    return await _db.rawDelete(
        'DELETE FROM playerteam WHERE player_id= ? and team_id= ?',
        [playerId, teamId]);
  }

  Future<List<Map>> getPlayerTeam(int teamId) async {
    Database _db = await createDB();
    var result = await _db
        .rawQuery('SELECT * FROM playerteam WHERE team_id=?', [teamId]);
    if (result != null) {
      return result.toList();
    }
    return null;
  }

  Future<List<Map>> getTeamsPlayer(int playerId) async {
    Database _db = await createDB();
    var result = await _db
        .rawQuery('SELECT * FROM playerteam WHERE player_id=?', [playerId]);
    if (result != null) {
      return result.toList();
    }
    return null;
  }
}
