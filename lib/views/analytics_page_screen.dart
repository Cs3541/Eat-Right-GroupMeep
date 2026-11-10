import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'nutrition_log_screen.dart';
import 'energy_log_screen.dart';

class AnalyticsPageScreen extends StatefulWidget {
  const AnalyticsPageScreen({super.key});

  @override State<AnalyticsPageScreen> createState() => _AnalyticsPageScreenState();

}

class _AnalyticsPageScreenState extends State<AnalyticsPageScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const EnergyLogScreen(),
    const NutritionLogScreen(),
  ];

  void _onItemTapped(int index)  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens [_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt),
            label: 'Energy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lunch_dining),
            label: 'Nutrition',
          )
        ]
      )
    );
  }
}