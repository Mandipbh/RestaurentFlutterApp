import 'package:flutter/material.dart';
import 'package:restaurent/screens/navigation/custom-bottom-nav-bar.dart';
import 'package:restaurent/screens/cart/cart_screen.dart';
import 'package:restaurent/screens/order_food/order_food.dart';
import 'package:restaurent/screens/restaurent/restaurent_screen.dart';
import 'package:restaurent/screens/settings/account_settings.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    OrderFood(),
    RestaurentScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

