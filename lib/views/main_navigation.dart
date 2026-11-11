import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profile_screen.dart';
import '../home_screen.dart';
import 'browse_screen.dart';
import 'analytics_page_screen.dart';


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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isLoggedIn = snapshot.data != null;

   
        final List<Widget> loggedInScreens = [
          HomeScreen(),
          BrowseScreen(),
          AnalyticsPageScreen(),
          ProfileScreen(),
        ];

   
        final List<Widget> loggedOutScreens = [
          LoginScreen(),
          SignupScreen(),
        ];

        final List<Widget> screens =
            isLoggedIn ? loggedInScreens : loggedOutScreens;

        final List<BottomNavigationBarItem> navItems =
            isLoggedIn
                ? const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'Browse',
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

        final int safeIndex =
            _selectedIndex.clamp(0, screens.length - 1);

        return Scaffold(
          body: screens[safeIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            currentIndex: safeIndex,
            onTap: _onItemTapped,
            items: navItems,
          ),
        );
      },
    );
  }
}