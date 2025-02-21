import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final bool showButtonBottomNavBar;

  const CustomBottomNavBar({Key? key, this.showButtonBottomNavBar = false})
      : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: widget.showButtonBottomNavBar
          ? _buildSingleButton() // Show single button if true
          : _buildNavigationBar(), // Show original design otherwise
    );
  }

  /// **Method to build the original bottom navigation bar**
  Widget _buildNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(Icons.home, "Home", 0),
        _buildNavItem(Icons.location_on, "Location", 1),
        _buildNavItem(Icons.shopping_cart, "Cart", 2),
        _buildNavItem(Icons.settings, "Settings", 3),
      ],
    );
  }

  Widget _buildSingleButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade900,
          fixedSize: Size(300, 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: Text(
          'ORDER NOW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// **Method to build navigation item**
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[900] : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.grey),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      label,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
