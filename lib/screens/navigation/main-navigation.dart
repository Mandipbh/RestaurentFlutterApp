import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/screens/cart/cart_screen.dart';
import 'package:restaurent/screens/navigation/custom-bottom-nav-bar.dart';
import 'package:restaurent/screens/order_food/order_food.dart';
import 'package:restaurent/screens/restaurent/restaurent_screen.dart';
import 'package:restaurent/screens/settings/account_settings.dart';

class MainNavigation extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return OrderFood();
      case 1:
        return RestaurentScreen();
      case 2:
        return CartScreen(1); // Dynamically recreated
      case 3:
        return ProfileScreen();
      default:
        return OrderFood();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "Exit App",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Do you want to close the app?",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Yes"),
          ),
        ],
      ),
    );

    if (result == true) {
      SystemNavigator.pop();
      return true;
    }
    return false; 
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          return await _showExitConfirmationDialog(context);
        } else {
          setState(() {
            _currentIndex = 0; // Navigate back to home screen instead of closing
          });
          return false;
        }
      },
      child: Scaffold(
        key: ValueKey(_currentIndex),
        body: _buildScreen(_currentIndex),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
