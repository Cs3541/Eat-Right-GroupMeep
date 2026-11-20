import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profile_screen.dart';
import '../home_screen.dart';
import 'browse_screen.dart';
import 'analytics_page_screen.dart';
import 'planner_screen.dart';
import 'dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppTheme.lightGreen,
            body: Center(
              child: CircularProgressIndicator(
                color: AppTheme.darkGreen,
              ),
            ),
          );
        }

        final bool isLoggedIn = snapshot.data != null;

        // Screens available when logged in
        final List<Widget> loggedInScreens = [
          HomeScreen(),
          DashboardPage(),
          BrowseScreen(),
          CalendarApp(),
          AnalyticsPageScreen(),
          ProfileScreen(),
        ];

        // Screens available when logged out
        final List<Widget> loggedOutScreens = [
          LoginScreen(),
          SignupScreen(),
        ];

        final List<Widget> screens =
            isLoggedIn ? loggedInScreens : loggedOutScreens;

        // Navigation items
        final List<BottomNavigationBarItem> navItems =
            isLoggedIn
                ? const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'Browse',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Planner',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.analytics),
                      label: 'Analytics',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ]
                : const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.login),
                      label: 'Login',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add),
                      label: 'Sign Up',
                    ),
                  ];

        // Prevent an invalid index after login/logout
        final int safeIndex =
            _selectedIndex.clamp(0, screens.length - 1);

        return Scaffold(
          backgroundColor: AppTheme.lightGreen,

          body: screens[safeIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: safeIndex,
            onTap: _onItemTapped,
            items: navItems,

            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.darkGreen,
            unselectedItemColor: AppTheme.mediumGreen,

            type: BottomNavigationBarType.fixed,
            elevation: 8,

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
