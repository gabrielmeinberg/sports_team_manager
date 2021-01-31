import 'package:team_manager/models/migrate.dart';

List migrations = [
  Migrate(
      '1',
      'CREATE TABLE IF NOT EXISTS player ( '
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT,'
          'create_at DATETIME DEFAULT CURRENT_TIMESTAMP)'),
  Migrate(
      '2',
      'CREATE TABLE IF NOT EXISTS team ( '
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT,'
          'create_at DATETIME DEFAULT CURRENT_TIMESTAMP)'),
  Migrate(
      '3',
      'CREATE TABLE IF NOT EXISTS playerteam ( '
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'player_id INTEGER,'
          'team_id INTEGER,'
          'create_at DATETIME DEFAULT CURRENT_TIMESTAMP)')
];
