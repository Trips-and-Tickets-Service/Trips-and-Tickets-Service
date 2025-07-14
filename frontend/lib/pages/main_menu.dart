import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../pages/search_page.dart';
import '../pages/planetarium_page.dart';
import '../pages/trips_page.dart';
import '../pages/settings_page.dart';
import '../data/styles.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    SearchPage(),
    TripsPage(),
    PlanetariumPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);
    tripsProvider.loadLanguage();

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: pinkColor,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: tripsProvider.languageCode == "en" ? 'Search' : 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: tripsProvider.languageCode == "en" ? 'My trips' : 'Мои билеты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: tripsProvider.languageCode == "en" ? 'Planetarium' : 'Планетарий',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: tripsProvider.languageCode == "en" ? 'Settings' : 'Настройки',
          ),
        ],
      ),
    );
  }
}