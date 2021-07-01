import 'package:code/Dashboard/Dashboard.dart';
import 'package:code/profile/ProfileScreen.dart';
import 'package:code/Activity/Activitys.dart';
import 'package:code/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';

import 'Activity/ActivityWarehouse.dart';

/// This is the stateful widget that the main application instantiates.
class NavigationBottom extends StatefulWidget {

  const NavigationBottom({Key? key}) : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _NavigationBottomState extends State<NavigationBottom> {

  ActivityWarehouse warehouse = ActivityWarehouse();
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    Activities(),
    Dashboard(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            label: 'Erfassen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Color.fromRGBO(66, 120, 151, 1.0),
        onTap: _onItemTapped,
      ),
    );
  }
}
