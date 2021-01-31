import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:team_manager/adapter/player_adapter.dart';
import 'package:team_manager/adapter/team_adapter.dart';
import 'package:team_manager/models/player.dart';
import 'package:team_manager/models/team.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    getPlayers();
    getTeams();
  }

  Key key = UniqueKey();
  List<PlayerEntity> listPlayerEntity = [];
  List<TeamEntity> listTeamEntity = [];
  bool dataDebtCollector = false;
  bool offline = true;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  PageController pageController = PageController();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void getPlayers() async {
    listPlayerEntity = await PlayerAdapter().getPlayers();

    notifyListeners();
  }

  void getTeams() async {
    listTeamEntity = await TeamAdapter().getTeams();

    notifyListeners();
  }
}
