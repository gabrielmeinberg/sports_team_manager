import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_manager/screens/player_screen.dart';
import 'package:team_manager/screens/team.dart';
import 'package:team_manager/screens/team_screen.dart';
import 'package:team_manager/screens/player.dart';

class MainApp extends StatefulWidget {
  MainApp({this.selectedIndex});

  final int selectedIndex;
  @override
  _MainApp createState() => _MainApp();
}

class _MainApp extends State<MainApp> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  FloatingActionButton getFloatingActionButton(BuildContext context) {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Player())),
        tooltip: 'Add new Player',
        child: Icon(Icons.add),
      );
    } else if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Team())),
        tooltip: 'Add new Team',
        child: Icon(Icons.add),
      );
    }
    return null;
  }

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex;
    }
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[PlayerScreen(), TeamScreen()];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("I'm the Captain"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          //Padding(
          //    padding: EdgeInsets.only(right: 20.0),
          //    child: GestureDetector(
          //      onTap: () => Navigator.push(context,
          //          MaterialPageRoute(builder: (context) => Settings())),
          //      child: Icon(Icons.settings),
          //    )),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: getFloatingActionButton(context),
    );
  }
}
